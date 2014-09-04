module Contactually
  class Utils
    class << self
      def params_without_id(params)
        params.clone.delete_if { |k,v| k == :id }
      end
    end
  end
end
