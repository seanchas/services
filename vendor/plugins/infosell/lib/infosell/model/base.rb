module Infosell
  module Model
    class Base
    
      attr_reader :attributes


      def self.cache(*args, &block)
        Rails.cache.fetch([I18n.locale, args, name.underscore].flatten.compact.join("/"), :expires_in => 1.minute, &block)
      end

      def self.proxy
        Infosell::Utils::Proxy.instance
      end
    
      def self.xmlrpc(name, *args)
        proxy.xmlrpc(name, *args)
      end
    
      def self.xmlrpc_with_session(name, *args)
        response = proxy.xmlrpc(name, proxy.session, *args)
        # Rails.logger.info "\n\n----\nname: #{name}, ARGS: #{args.inspect}\nresponse: #{response.inspect}\n----\n\n"
        response
      end
      
      def self.instance_or_find(param, klass)
        param.is_a?(klass) ? param : klass.find(param)
      end
      
      def freeze
        self
      end

      def instance_or_find(*args)
        self.class.instance_or_find(*args)
      end

    
      def initialize(attributes, *args)
        @attributes = {}
        self.attributes = attributes
      end
    
      def attributes=(attributes)
        attributes.each do |name, value|
          send(:"#{name}=", value)
        end
      end
    
      def known_attributes
        attributes.keys
      end
    
      def to_param
        id.to_s
      end
    
      def id
        attributes["id"]
      end
    
      def new_record?
        !persisted?
      end
    
      def persisted?
        @persisted
      end
    
      def persist!
        @persisted = true
      end
    
      def respond_to?(*args)
        super || known_attributes.include?(args.first.to_s)
      end

      def method_missing(name, *args, &block)
        method_name = name.to_s
        case method_name.last
          when "="
            attributes[method_name.first(-1)] = args.first
          when "?"
            !!attributes[method_name.first(-1)]
          else
            known_attributes.include?(method_name) ? attributes[method_name] : super
        end
      end
    
    end
  end
end
