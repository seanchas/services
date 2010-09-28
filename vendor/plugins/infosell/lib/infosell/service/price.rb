module Infosell
  class Service
    
    class Price < XmlBase

      def self.for(service)
        cache(service.id) do
          Nokogiri::XML(xmlrpc_with_session("getPriceList", service.id)).css("elements element").collect { |node| new(parse_element(node)).tap(&:persist!) }
        end
      end
      
      def self.parse_element(xml)
        {
          :id     => xml.attribute("id").content,
          :title  => xml.at_css("title").content,
          :prices => xml.css("prices price").collect { |node| Base.new(:label => node.attribute("label").content, :value => node.attribute("value").content) },
          :links  => xml.css("links link").collect { |node| Base.new(:label => node.attribute("label").content, :url => node.attribute("url").content ) }
        }
      end
      
    end
    
  end
end
