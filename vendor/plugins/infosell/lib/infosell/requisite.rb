module Infosell
  class Requisite < Infosell::Model::Base

    extend ActiveSupport::Memoizable
    
    
    def self.find(*params)
      requisites = params.collect do |param|
        new(Infosell::RequisiteType.for(param.to_s), xmlrpc_with_session("getUserProfile", param.to_s)).tap(&:persist!) rescue nil
      end.compact
    end
    

    delegate :columns, :fields, :to => :form
    
    def id
      code rescue nil
    end
    
    def form
      RequisiteForm.for(requisite_type)
    end
    memoize :form
    
    
    def human_attribute_name(attribute)
      columns.include?(attribute.to_s) ? fields[attribute.to_s].label : attribute.to_s.underscore.humanize
    end
    
    
    def errors
      @errors ||= Infosell::Model::Errors.new(self)
    end
    
    def save
      create_or_update
      errors.empty?
    end
    
    def update_attributes(attributes = {})
      self.attributes = attributes
      save
    end
    
    def create_or_update
      new_record? ? create : update
    rescue XMLRPC::FaultException => e
      ActiveSupport::JSON.decode(e.faultString).each do |key, message|
        errors.add(key, message)
      end
    end
    
    def create
      self.class.xmlrpc_with_session("addUser", requisite_type.id, to_infosell)
    end
    
    def update
      self.class.xmlrpc_with_session("updateUserProfile", to_param, to_infosell)
    end
    
    def to_infosell
      columns.inject({}) do |container, column|
        container[column] = send(:"#{column}") || ""
        container
      end.merge(:code => to_param)
    end


    def requisite_type=(requisite_type)
      attributes["requisite_type"] = instance_or_find(requisite_type, Infosell::RequisiteType)
    end
    
    def initialize(requisite_type, arguments = {})
      super(arguments)
      self.requisite_type = requisite_type
    end
    
    def respond_to?(*args)
      super || columns.include?(args.first.to_s)
    end
    
    def column_value(name)
      form.elements[name].value.value
    end
    
    def method_missing(name, *args, &block)
      method_name = name.to_s
      case method_name.last
        when "="
          attributes[method_name.first(-1)] = args.first
        when "?"
          !!attributes[method_name.first(-1)]
        else
          if attributes.key?(method_name)
            attributes[method_name]
          elsif columns.include?(method_name)
            fields[method_name].value.value
          else
            super
          end
      end
    end

  end
end
