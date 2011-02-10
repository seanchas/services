class WelcomeController < ApplicationController
  
  include MicexXMLRPC::ControllerMixins

  def index
    redirect_to :services
  end
  
  def unauthenticated
    redirect_to :root
  end
  
  def xmlrpc
    handle_xmlrpc_request and return if request.post?
    @xmlrpc_methods = xmlrpc_methods
  end
  
end
