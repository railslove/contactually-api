module Contactually
  class Utils

    class << self
      def method_missing(m, *args)
        case m
        when /^(\w*)_hash_to_objects/ then
          hash_to_objects($1, *args)
        when /^build_(\w*)/ then
          build_object($1, *args)
        else
          super(m, *args)
        end
      end

      def respond_to?(m, *args)
        case m
        when /^(\w*)_hash_to_objects/ then
          true
        when /^build_(\w*)/ then
          true
        else
          super(m, *args)
        end
      end

      private

      def hash_to_objects(type, hash)
        representer_class = "Contactually::Representer::#{type.classify}Representer".constantize
        object_class = "Contactually::#{type.classify}".constantize
        hash[type].inject([]) do |arr, obj|
          arr << representer_class.new(object_class.new).from_hash(obj)
        end
      end

      def build_object(type, hash)
        representer_class = "Contactually::Representer::#{type.classify}Representer".constantize
        object_class = "Contactually::#{type.classify}".constantize
        representer_class.new(object_class.new).from_hash(hash)
      end
    end
  end
end
