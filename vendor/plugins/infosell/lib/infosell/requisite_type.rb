module Infosell

  class RequisiteType < Infosell::Model::Base
    
    def self.all
      cache do
        xmlrpc_with_session("getUserTypeList").collect { |attributes| new(attributes) }
      end
    end
    
    def self.find(param)
      all.detect { |requisite_type| requisite_type.to_param == param.to_s }
    end
    
    def self.for(param)
      find(xmlrpc_with_session("getUserTypeId", param.to_s))
    end
    
  end

end
