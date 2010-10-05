module Infosell
  
  class ServiceOffer < Infosell::Model::Base
    
    def self.for(service)
      cache(service.id) do
        new(xmlrpc_with_session("getTextPublicOffer", service.id, I18n.locale)).tap(&:persist!)
      end
    end
    
    def data=(data)
      attributes["data"] = Iconv.conv("utf-8", "windows-1251", ActiveSupport::Base64.decode64(data))
    end
    
  end
  
end
