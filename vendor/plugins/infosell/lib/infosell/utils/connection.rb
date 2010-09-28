require 'uri'
require 'xmlrpc/client'

module Infosell
  module Utils
    
    class Connection
      
      def self.fetch
        new(Infosell.site)
      end
      
      def initialize(uri)
        @uri = uri.is_a?(URI) ? uri : URI.parse(uri)
      end
      
      def call(name, *args)
        xmlrpc.call(name, *args)
      end
    
    private
    
      def xmlrpc
        @xmlrpc ||= XMLRPC::Client.new(@uri.host, @uri.path, @uri.port)
      end
      
    end
    
  end
end
