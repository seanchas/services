module Infosell
  class Base
    
    attr_reader :attributes

    
    def self.schema(&block)
      if block_given?
        new_schema = Infosell::Utils::Schema.new
        new_schema.instance_eval(&block)
        
        return unless new_schema.attributes.present?
        
        @schema           ||= {}
        @known_attributes ||= []
        
        new_schema.attributes.each do |name, value|
          @schema[name] = value
          @known_attributes << name
        end
        
        schema
      else
        @schema ||= nil
      end
    end
    
    def self.known_attributes
      @known_attributes ||= []
    end
    
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
      proxy.xmlrpc(name, proxy.session, *args)
    end
      
    
    def initialize(attributes)
      @attributes = {}
      self.attributes = attributes
    end
    
    def attributes=(attributes)
      attributes.each do |name, value|
        send(:"#{name}=", value)
      end
    end
    
    def to_param
      id.to_s
    end
    
    def id
      attributes["id"]
    end
    
    def new_record?
      !persist?
    end
    
    def persist?
      @persist
    end
    
    def persist!
      @persist = true
    end
    
    def method_missing(name, *args, &block)
      method_name = name.to_s
      case method_name.last
        when "="
          attributes[method_name.first(-1)] = args.first
        when "?"
          !!attributes[method_name.first(-1)]
        else
          attributes.key?(method_name) ? attributes[method_name] : super
      end
    end
    
  end
end
