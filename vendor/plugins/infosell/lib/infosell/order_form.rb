module Infosell
  
  class OrderForm < Infosell::Model::XMLBase
    
    def self.for(service, requisite)
      service   = instance_or_find(service, Infosell::Service)
      requisite = instance_or_find(requisite, Infosell::Requisite)
      new(xmlrpc_with_session("getNewOrderForm", requisite.id, service.id))
    end
    
    def self.parse(xml)
      {
        :elements => xml.css("group").last.css("element").collect { |element_xml| Infosell::XMLFormElement.new(element_xml) }
      }
    end
    
    def fields
      @fields ||= elements.inject({}) do |container, element|
        container[element.id] = element
        container
      end
    end
    
    def columns
      @columns ||= fields.keys
    end
    
  end

end
