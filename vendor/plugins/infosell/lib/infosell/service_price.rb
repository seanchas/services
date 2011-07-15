module Infosell
  
  class ServicePrice < Infosell::Model::XMLBase

    def self.for(service, user_id)
      cache(service.id, user_id) do
        Nokogiri::XML(xmlrpc_with_session("getPriceList", service.id, user_id)).css("elements element").collect { |price_xml| new(price_xml).tap(&:persist!) }
      end
    end
    
    def self.parse(xml)
      Rails.logger.debug "XML: \n #{xml}"
      {
        :id           => xml.attribute("id").content,
        :title        => xml.at_css("title").content,
        :description  => xml.at_css("description").content,
        :prices       => xml.css("prices price").collect { |node| Infosell::Model::Base.new(:label => node.attribute("label").content, :value => node.attribute("value").content) },
        :links        => xml.css("links link").collect { |node| Infosell::Model::Base.new(:label => node.attribute("label").content, :url => node.attribute("url").content ) }
      }
    end
    
  end

end
