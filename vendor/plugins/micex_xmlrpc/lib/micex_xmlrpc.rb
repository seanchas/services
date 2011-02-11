module MicexXMLRPC

  autoload :Server,           'micex_xmlrpc/server'
  autoload :Backend,          'micex_xmlrpc/backend'
  autoload :Controller,       'micex_xmlrpc/controller'
  autoload :Logger,           'micex_xmlrpc/logger'
  autoload :ControllerMixins, 'micex_xmlrpc/controller_mixins'

  mattr_accessor :load_path
  @@load_path = []
  
  def self.server
    @@server ||= MicexXMLRPC::Server.new
  end
  
  def self.reload!
    @@server = nil
  end
  
  def self.logger
    @@logger ||= begin
      logfile       = File.open(File.join(RAILS_ROOT, 'log', 'xmlrpc.log'), 'a')
      logfile.sync  = true
      Logger.new(logfile)
    end
  end
  
end
