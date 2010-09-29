module Infosell
  
  class Service < Model::Base
    
    def self.all
      cache do
        xmlrpc_with_session("getServiceSet").collect { |attributes| new(attributes).tap(&:persist!) }
      end
    end
    
    def self.find(param)
      all.find { |service| service.to_param == param.to_s }
    end
    
    def description
      @description ||= Infosell::Service::Description.for(self)
    end
    
    def offer
      @offer ||= Infosell::Service::Offer.for(self)
    end
    
    def prices
      @prices ||= Infosell::Service::Price.for(self)
    end
    
    def curr=(curr)
      attributes["currency"] = curr.downcase.to_sym
    end
    
    def web=(web)
      attributes["accessible"] = web
    end
    
  end
  
end
