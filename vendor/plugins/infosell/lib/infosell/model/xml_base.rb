require 'nokogiri'

module Infosell
  module Model
  
    class XMLBase < Base
      
      def self.new(xml)
        super(parse(xml.is_a?(String) ? Nokogiri::XML(xml) : xml))
      end
      
      def self.parse(xml)
        {}
      end
      
    end
  
  end
end
