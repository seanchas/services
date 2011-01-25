module Infosell

  class Resource < Infosell::Model::Base
    
    class Invalid < StandardError
    end
    
    def self.all
      xmlrpc_with_session("getResourceList").collect { |attributes| new(attributes).tap(&:persist!).tap(&:store_code!) }
    end
    
    def self.find(param)
      all.detect { |resource| resource.to_param == param.to_param }
    end
    
    def id
      Digest::SHA1.hexdigest(@stored_code) if persisted?
    end
    
    def description=(value)
      attributes["description_ru"] = value["ru"]
      attributes["description_en"] = value["en"]
    end
    
    def kind=(value)
      attributes["resource_kind_id"] = value
    end
    
    def kind
      @kind ||= Infosell::ResourceKind.find(resource_kind_id)
    end
    
    def save
      create_or_update
      errors.empty?
    end
    
    def save!
      save or raise Infosell::Resource::Invalid
    end
    
    def update_attributes(attributes = {})
      self.attributes = attributes
      save
    end
    
    def update_attributes!(attributes = {})
      update_attributes(attributes) or raise Infosell::Resource::Invalid
    end
    
    def destroy
      self.class.xmlrpc_with_session("deleteResource", @stored_code)
    end
    
    def errors
      @errors ||= Infosell::Model::Errors.new(self)
    end
  
  private
  
    def create_or_update
      new_record? ? create : update
    rescue XMLRPC::FaultException => e
      errors[:base] = e.faultString
    end
    
    def infosell_attributes
      [
        attributes["code"],
        attributes["resource_kind_id"],
        attributes["name"],
        attributes["description_ru"],
        attributes["description_en"]
      ]
    end
    
    def create
      self.class.xmlrpc_with_session("addResource", *infosell_attributes)
      store_code!
      persist!
    end
    
    def update
      self.class.xmlrpc_with_session("updateResource", @stored_code, *infosell_attributes)
    end
    
    def store_code!
      @stored_code = code
    end
    
  end

end
