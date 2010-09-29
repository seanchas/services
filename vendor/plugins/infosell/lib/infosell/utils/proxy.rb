module Infosell
  module Utils
    
    class Proxy

      attr_reader :env
      
      def self.instance=(instance)
        @@instance = instance
      end
      
      def self.instance
        @@instance ||= new({})
      end
      
      def initialize(env)
        @env = env
        self.class.instance = self
      end
      
      def xmlrpc(name, *args)
        connection.call(name, *args)
      end
      
      def session
        @session ||= Infosell::Utils::Session.fetch
      end
    
    private
    
      def connection
        @connection ||= Infosell::Utils::Connection.fetch
      end
      
    end
    
  end
end
