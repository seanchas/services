module Infosell
  module OrderMixins

    def isEdit=(value)
      attributes["editable"] = value
    end
    
    def buyAddCnt=(value)
      attributes["connections_editable"] = value
    end

    def access=(value)
      attributes["access_provided"] = value == 1
    end
    
    def status=(value)
      attributes["state"] = value.to_sym
    end
    
    def total
      attributes["total"] || 0
    end
    
    def discount
      attributes["discount"] || 0
    end
    
    [:usd, :refRequest, :infosell_type].each do |name|
      class_eval <<-METHOD, __FILE__, __LINE__ + 1
        def #{name}=(value);end
      METHOD
    end
    
    [:discount, :total].each do |name|
      class_eval <<-METHOD, __FILE__, __LINE__ + 1
        def #{name}=(value)
          attributes["#{name}"] = value.to_s.sub("`decimal`", "").to_f
        end
      METHOD
    end
    
    [:ordered_at, :ordered_from, :ordered_till, :confirmed_at].each do |name|
      class_eval <<-METHOD, __FILE__, __LINE__ + 1
        def #{name}=(value)
          attributes["#{name}"] = value.blank? ? nil : value.to_date
        end
      METHOD
    end
    
  end
end
