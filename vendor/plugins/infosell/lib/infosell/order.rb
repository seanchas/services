module Infosell

  class Order < Infosell::Model::Base
    
    include Infosell::OrderMixins
    
    attr_reader :service, :requisite
    
    attr_accessor :accept_offer
    
    delegate :columns, :fields, :to => :form
    
    def self.all(requisite, options = {})
      requisite = Array(instance_or_find(requisite, Infosell::Requisite)).first
      
      options[:state] ||= [:new, :opened, :closed]
      options[:from]  ||= 1.year.ago
      options[:till]  ||= Time.now
      
      xmlrpc_with_session("getOrderList", requisite.id, [options[:state]].flatten.compact, options[:from].to_date.to_s(:db), options[:till].to_date.to_s(:db)).collect do |attributes|
        service = Service.find_by_kind_and_type(attributes["kind"], attributes["type"])
        new(service, requisite, attributes).tap(&:persist!)
      end
    end
    
    
    def self.find(requisite, param)
      requisite   = Array(instance_or_find(requisite, Infosell::Requisite)).first
      attributes  = xmlrpc_with_session("getOrder", requisite.id, param)
      service     = Service.find_by_kind_and_type(attributes["kind"], attributes["type"])

      new(service, requisite, attributes).tap(&:persist!)
    end
    
    
    def initialize(service, requisite, attributes = {})
      self.service    = service
      self.requisite  = requisite
      super(attributes)
    end
    
    def service=(service)
      @service = instance_or_find(service, Infosell::Service)
    end
    
    def requisite=(requisite)
      @requisite = instance_or_find(requisite, Infosell::Requisite)
    end
    
    def form
      @form ||= Infosell::OrderForm.for(service, requisite)
    end

    def known_attributes
      @known_attributes ||= attributes.reverse_merge(fields)
    end
    
    def accept_offer?
      accept_offer == "1"
    end
    
    def blocks=(blocks)
      @blocks = nil
      @blocks_ids = blocks.collect { |block| block["id"] }
    end
    
    def blocks
      @blocks ||= service.blocks.select { |block| blocks_ids.include?(block.id) }
    end
    
    def blocks_ids
      @blocks_ids ||= []
    end
    
    def blocks_ids=(blocks_ids)
      @blocks = nil
      @blocks_ids = blocks_ids.collect(&:to_i).compact.uniq
    end
    
    # saving
    
    def errors
      @errors ||= Infosell::Model::Errors.new(self)
    end
    
    def save
      create_or_update
      errors.empty?
    end
    
    def update_attributes(attributes)
      self.attributes = attributes
      save
    end
    
    def create_or_update
      new_record? ? create : update
    end
    
    def create
      self.class.xmlrpc_with_session("applyUserOffer", requisite.id, service.id) if accept_offer?
      self.class.xmlrpc_with_session("addOrder", requisite.id, to_infosell)
    end
    
    def update
      self.class.xmlrpc_with_session("updateOrder", requisite.id, id, to_infosell)
    end
    
    def to_infosell
      {
        :service_id   => service.id,
        :block_ids    => blocks.collect(&:id),
        :duration     => duration,
        :granted_from => granted_from,
        :connections  => (connections rescue 0)
      }
    end
    
  end

end

