module Infosell
  
  class XMLFormElement < Infosell::Model::XMLBase
    
    def self.parse(xml)
      element_type = xml.attribute("type").try(:content)
      {
        :id           => xml.attribute("id").try(:content),
        :label        => xml.attribute("label").try(:content),
        :hint         => xml.attribute("hint").try(:content),
        :required     => xml.attribute("required").try(:content) == "true",
        :element_type => element_type,
        :value_type   => xml.attribute("value_type").try(:content),
        :value        => Infosell::XMLFormElementValue.new(element_type, xml.css("value"))
      }
    end
    
  end
  
end
