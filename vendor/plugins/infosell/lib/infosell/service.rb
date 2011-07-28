module Infosell
  
  class Service < Infosell::Model::Base
    
    attr_reader :blocks
    
    def self.all(user_id = '')
      cache(user_id) do
        xmlrpc_with_session("getServiceSet", user_id).collect { |attributes| new(user_id, attributes).tap(&:persist!) }
      end
    end
    
    def self.find(param, user_id = '')
      all(user_id).find { |service| service.to_param == param.to_s }
    end
    
    def self.find_by_kind_and_type(kind, type, user_id = '')
      all(user_id).detect { |service| service.kind == kind && service.type == type }
    end
    
    def initialize(user_id, attributes = {})
      @user_id = user_id
      super(attributes)
    end

    def type
      attributes["type"]
    end
    
    def description
      @description ||= Infosell::ServiceDescription.for(self, @user_id)
    end
    
    def offer
      @offer ||= Infosell::ServiceOffer.for(self)
    end
    
    def offer?
      !offer.data.blank?
    end
    
    def prices
      @prices ||= Infosell::ServicePrice.for(self, @user_id)
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
