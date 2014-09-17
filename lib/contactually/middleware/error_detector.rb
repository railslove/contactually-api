module Contactually
  module Middleware
    class ErrorDetector < Faraday::Middleware

      def call(env)
        @app.call(env).on_complete do
          unless (200..299).include? env[:status]
            cast_error(env[:body])
          end
        end
      end

    private

      def cast_error(body)
        case JSON.parse(body)['error']
        when /^Invalid parameters/ then
          raise InvalidParametersError, body
        when /^We already have/ then
          raise DuplicatedContactError, body
        else
          raise APIError, body
        end
      end
    end
  end
end
