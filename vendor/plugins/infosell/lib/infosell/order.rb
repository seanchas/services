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
        service = Service.find_by_kind_and_type(attributes["kind"], attributes["type"], requisite.to_param)
        new(service, requisite, attributes).tap(&:persist!)
      end
    end
    
    
    def self.find(requisite, param)
      requisite   = Array(instance_or_find(requisite, Infosell::Requisite)).first
      attributes  = xmlrpc_with_session("getOrder", requisite.id, param)
      service     = Service.find_by_kind_and_type(attributes["kind"], attributes["type"], requisite.to_param)

      new(service, requisite, attributes).tap(&:persist!)
    end
    
    
    def self.destroy(requisite, *ids)
      requisite = Array(instance_or_find(requisite, Infosell::Requisite)).first
      ids.each do |id|
        xmlrpc_with_session("deleteOrder", requisite.id, id.to_i)
      end
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
      attributes.reverse_merge(fields).keys
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
    
    def human_attribute_name(attribute)
      columns.include?(attribute.to_s) ? fields[attribute.to_s].label : attribute.to_s.underscore.humanize
    end

    def errors
      @errors ||= Infosell::Model::Errors.new(self)
    end
    
    def validate
      parameters = to_infosell
      parameters[:id] = id unless new_record?
      self.attributes = self.class.xmlrpc_with_session("getUserCartInfo", requisite.id, parameters)
    rescue XMLRPC::FaultException => e
      errors.add(:base, e.faultString)
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
    rescue XMLRPC::FaultException => e
      errors.add(:base, e.faultString)
    end
    
    def create
      # self.class.xmlrpc_with_session("getUserOffer",   requisite.id, service.id) if accept_offer?
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
        :ordered_from => ordered_from.to_date.to_s(:db),
        :connections  => (connections rescue 0),
        :from         => (from rescue ''),
        :till         => (till rescue '')
      }
    end
    
    def method_missing(name, *args, &block)
      method_name = name.to_s
      case method_name.last
        when "="
          super
        when "?"
          super
        else
          attributes.key?(method_name) ? attributes[method_name] : fields.key?(method_name) ? fields[method_name] : super
      end
    end

  end

end
