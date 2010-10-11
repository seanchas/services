module Infosell
  
  class Service < Infosell::Model::Base
    
    attr_reader :blocks
    
    def self.all
      cache do
        xmlrpc_with_session("getServiceSet").collect { |attributes| new(attributes).tap(&:persist!) }
      end
    end
    
    def self.find(param)
      all.find { |service| service.to_param == param.to_s }
    end
    
    def self.find_by_kind_and_type(kind, type)
      all.detect { |service| service.kind == kind && service.type == type }
    end
    
    def type
      attributes["type"]
    end
    
    def description
      @description ||= Infosell::ServiceDescription.for(self)
    end
    
    def offer
      @offer ||= Infosell::ServiceOffer.for(self)
    end
    
    def offer?
      !offer.data.blank?
    end
    
    def prices
      @prices ||= Infosell::ServicePrice.for(self)
    end
    
    def prices?
      !prices.empty?
    end
    
    def curr=(curr)
      attributes["currency"] = curr.downcase.to_sym
    end
    
    def web=(web)
      attributes["accessible"] = web
    end
    
    def blocks=(blocks)
      @blocks = blocks.collect { |block_attributes| Infosell::ServiceBlock.new(block_attributes) }
    end
    
  end
  
end
