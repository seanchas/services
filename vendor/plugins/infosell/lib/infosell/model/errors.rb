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
      
      def add(attribute, message)
        self[attribute] << message
      end
      
    end
    
  end
end
