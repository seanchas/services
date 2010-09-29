module Infosell
  
  class XMLFormGroup < Infosell::Model::XMLBase
    
    def self.parse(xml)
      {
        :title    => xml.attribute("title").try(:content),
        :elements => xml.css("element").collect { |element_xml| XMLFormElement.new(element_xml) }
      }
    end
    
  end
  
end
