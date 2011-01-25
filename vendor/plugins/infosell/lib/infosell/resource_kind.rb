module Infosell

  class ResourceKind < Infosell::Model::Base
    
    def self.all
      cache do
        xmlrpc_with_session("getResourceKindList").collect { |attributes| new(attributes) }
      end
    end
    
    def self.find(param)
      all.detect { |resource_kind| resource_kind.to_param == param.to_s }
    end
    
  end

end
