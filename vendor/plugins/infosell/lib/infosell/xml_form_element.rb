module Infosell
  
  class XMLFormElement < Infosell::Model::XMLBase
    
    def self.parse(xml)
      element_type = xml.attribute("type").try(:content)
      id           = xml.attribute("id").try(:content)
      {
        :id           => id,
        :label        => xml.attribute("label").try(:content),
        :hint         => xml.attribute("hint").try(:content),
        :required     => xml.attribute("required").try(:content) == "true",
        :element_type => element_type,
        :value_type   => xml.attribute("value_type").try(:content),
        :value        =>
            case id.to_sym
              when :from
                Infosell::XMLFormElementValue.new(id, xml.css("value"))
              when :till
                Infosell::XMLFormElementValue.new(id, xml.css("value"))
              else
                Infosell::XMLFormElementValue.new(element_type, xml.css("value"))
            end
      }
    end
    
  end
  
end
