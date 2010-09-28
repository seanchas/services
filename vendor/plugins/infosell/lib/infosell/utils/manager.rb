module Infosell
  module Utils
    
    class Manager
      
      def initialize(app, options = {}, &block)
        @app = app
      end
      
      def call(env)
        Infosell::Utils::Proxy.new(env)
        @app.call(env)
      end
      
    end
    
  end
end
