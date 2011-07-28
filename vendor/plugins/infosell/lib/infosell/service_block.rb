module Infosell
  
  class ServiceBlock < Infosell::Model::Base

    def desc=(value)
      attributes['description'] = value.to_s
    end

    [:price, :price4, :price7].each do |name|
      class_eval <<-METHOD, __FILE__, __LINE__ + 1
      
        def #{name}=(value)
          attributes["#{name}"] = value.to_s.sub(/`.*`/, '').to_f
        end
      
      METHOD
    end
    
  end
  
end
