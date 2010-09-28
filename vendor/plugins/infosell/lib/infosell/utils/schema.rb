module Infosell
  module Utils
    
    class Schema

      KNOWN_ATTRIBUTE_TYPES = %w(string text integer float decimal datetime timestamp time date binary boolean)
      
      attr_accessor :attributes
      
      def initialize
        @attributes = {}
      end
      
      def attribute(name, type, options = {})
        raise ArgumentError, "Unknown Attribute type: #{type.inspect} for key: #{name.inspect}" unless type.nil? || Schema::KNOWN_ATTRIBUTE_TYPES.include?(type.to_s)
        attributes[name.to_s] = type.to_s
        self
      end
      
      KNOWN_ATTRIBUTE_TYPES.each do |type|
        class_eval <<-METHOD, __FILE__, __LINE__ + 1
        
          def #{type}(*args)
            options = args.extract_options!
            names = args
            
            names.each do |name|
              attribute(name, "#{type}", options)
            end
          end
        
        METHOD
      end
      
    end
    
  end
end
