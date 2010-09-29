module Infosell
  
  class RequisiteForm < Infosell::Model::XMLBase
    
    extend ActiveSupport::Memoizable
    
    def self.for(requisite_type)
      requisite_type = instance_or_find(requisite_type, Infosell::RequisiteType)
      cache(requisite_type.id) do
        new(xmlrpc_with_session("getNewUserForm", requisite_type.id))
      end
    end
    
    def self.parse(xml)
      {
        :groups => xml.css("group").collect { |group_xml| Infosell::XMLFormGroup.new(group_xml) }
      }
    end
    
    def fields
      groups.collect(&:elements).flatten.inject({}) do |container, element|
        container[element.to_param] = element
        container
      end
    end
    memoize :fields
    
    def columns
      fields.keys
    end
    memoize :columns
    
  end
  
end
