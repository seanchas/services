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
    
    def accept_offer?
      accept_offer == "1"
    end
    
    def form
      @form ||= Infosell::OrderForm.for(service, requisite)
    end

    def known_attributes
      @known_attributes ||= (attributes.collect(&:key) + columns).flatten.compact.uniq
    end
    
    def schema(attribute)
      attributes[attribute] || fields[attribute].value.value if known_attributes.include?(attribute)
    end
    
    # -- to be removed
    def granted_from
      attributes["granted_from"] || fields["granted_from"].value.value
    end
    
    def duration
      attributes["duration"] || fields["duration"].value.value
    end
    
    def connections
      attributes["connections"] || fields["connections"].value.value
    end
    # -- to be removed
    
    def blocks=(blocks)
      @blocks = service.blocks.select { |block| blocks.collect { |b| b["id"] }.include?(block.id) }
    end
    
    def blocks
      @blocks ||= service.blocks.collect { |block| block.included = blocks_ids.include?(block.id); block }
    end
    
    def blocks_ids
      @blocks_ids ||= []
    end
    
    def blocks_attributes=(attributes)
      @blocks_ids = service.blocks.values_at(*attributes.reject { |first, last| last[:included] == "0" }.collect(&:first).collect(&:to_i)).collect(&:id)
    end
    
    # saving
    
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
      self.class.xmlrpc_with_session("applyUserOffer", requisite.id, service.id) if accept_offer?
      self.class.xmlrpc_with_session("addOrder", requisite.id, to_infosell)
    end
    
    def update
    end
    
    def to_infosell
      attributes.merge(:block_ids => blocks_ids, :service_id => service.id)
    end
    
  end

end

