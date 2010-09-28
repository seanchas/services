module Infosell
  
  module Utils
    autoload :Manager,    'infosell/utils/manager'
    autoload :Proxy,      'infosell/utils/proxy'
    autoload :Connection, 'infosell/utils/connection'
    autoload :Schema,     'infosell/utils/schema'
  end
  
  mattr_accessor :type
  @@type = nil
  
  mattr_accessor :site
  @@site = nil
  
  mattr_accessor :cache
  @@cache = nil
  
  def self.configure(&block)
    if block_given?

      require 'infosell/utils/rails'

      if block.arity == 1
        yield(self)
      else
        instance_eval(&block)
      end
    end
  end
  
end
