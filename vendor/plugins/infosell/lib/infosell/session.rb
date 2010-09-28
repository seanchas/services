module Infosell
  
  module Session
    
    extend self
    
    def fetch
      rack_session[session_key] = open_session unless check_session(rack_session[session_key])
      rack_session[session_key]
    end
  
  private
  
    def check_session(session_id)
      proxy.xmlrpc("checkSession", session_id) unless session_id.nil?
    end
    
    def open_session
      proxy.xmlrpc("openSession", Infosell.type, I18n.locale)
    end
  
    def session_key
      :"#{I18n.locale}_infosell_session_id"
    end
  
    def rack_session
      proxy.env['rack.session'] ||= {}
    end
    
    def proxy
      Infosell::Utils::Proxy.instance
    end
    
  end
  
end
