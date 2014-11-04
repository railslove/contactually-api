module Contactually
  module Middleware
    class ErrorDetector < Faraday::Middleware

      def call(env)
        @app.call(env).on_complete do |env|
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
        when /^You need to sign in/ then
          raise AuthenticationError, body
        else
          raise APIError, body
        end
      rescue JSON::ParserError
        raise APIError, body
      end
    end
  end
end
