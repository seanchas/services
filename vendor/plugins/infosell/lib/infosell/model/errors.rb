module Infosell
  module Model
    
    class Errors < Hash
      
      def initialize(base)
        @base = base
        super
      end
      
      alias_method :get, :[]
      alias_method :set, :[]=
      
      def [](attribute)
        key?(attribute.to_sym) ? get(attribute.to_sym) : set(attribute.to_sym, [])
      end
      
      def []=(attribute, message)
        self[attribute] << message
      end
      
      def empty?
        all? { |k, v| v && v.empty? }
      end
      
      def full_messages
        values.flatten
      end
      
      def add(attribute, message)
        self[attribute] << generate_message(attribute, message)
      end
      
      def generate_message(attribute, message)
        message.sub(/(\#\{field\})/, %("#{@base.human_attribute_name(attribute)}"))
      end
      
    end
    
  end
end
