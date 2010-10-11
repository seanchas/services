module Infosell
  
  module Model
    autoload :Base,       'infosell/model/base'
    autoload :XMLBase,    'infosell/model/xml_base'
  end
  
  module Utils
    autoload :Manager,    'infosell/utils/manager'
    autoload :Proxy,      'infosell/utils/proxy'
    autoload :Connection, 'infosell/utils/connection'
    autoload :Session,    'infosell/utils/session'
  end
  
  autoload :Service, 'infosell/service'
  autoload :XMLFormGroup, 'infosell/xml_form_group'
  autoload :XMLFormElement, 'infosell/xml_form_element'
  autoload :XMLFormElementValue, 'infosell/xml_form_element_value'
  
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
