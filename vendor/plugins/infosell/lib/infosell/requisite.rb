module Infosell
  class Requisite < Infosell::Model::Base

    extend ActiveSupport::Memoizable

    delegate :columns, :fields, :to => :form
    
    def form
      RequisiteForm.for(requisite_type)
    end
    memoize :form
    
    
    def errors
      @errors ||= Infosell::Model::Errors.new(self)
    end
    
    def save
      create_or_update
      errors.empty?
    end
    
    def create_or_update
      new_record? ? create : update
    end
    
    def create
      self.class.xmlrpc_with_session("addUser", requisite_type.id, to_infosell)
    rescue XMLRPC::FaultException => e
      ActiveSupport::JSON.decode(e.faultString).each do |key, message|
        errors.add(key, message)
      end
    end
    
    def update
      false
    end
    
    def to_infosell
      columns.inject({}) do |container, column|
        container[column] = send(:"#{column}")
        container
      end
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
