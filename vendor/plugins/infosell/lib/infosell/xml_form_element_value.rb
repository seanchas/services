module Infosell
  
  class XMLFormElementValue < Infosell::Model::XMLBase

    def self.new(element_type, xml)
      super(xml).extend(const_get(element_type.classify)).tap(&:parse)
    end
    
    def self.parse(xml)
      { :value => xml }
    end
    
    def options_for_tag
      {}
    end
    

    module Text

      def parse
        self.value = value.first.content
      end

      def tag
        :text_field
      end

    end
    

    module Textarea

      def parse
        self.value = value.first.content
      end

      def tag
        :text_area
      end

    end
    

    module Select

      def parse
        self.options = value.collect do |xml|
          Infosell::Model::Base.new(
            :label    => xml.attribute("label").try(:content),
            :value    => xml.content,
            :selected => xml.attribute("selected").try(:content) == "true"
          )
        end
        self.value = options.detect(&:selected)
      end
      
      def tag
        :select
      end

      def options_for_tag
        options.collect { |option| [option.label, option.value.to_i] }
      end

    end
    

    module Checkbox
      
      def tag
        :checkbox
      end
      
    end
    
    
    module Date

      def parse
        self.value = value.first.content.to_date
      end
      
      def tag
        :text_field
      end
      
      def options_for_tag
        { :"data-format" => "calendar" }
      end
      
    end
    
    
    module Range
      
      def parse
        @from = value.first.attribute("from").content
        @to = value.first.attribute("to").content
        self.value = value.first.content
      end
      
      def tag
        :select
      end
      
      def options_for_tag
        (@from..@to).collect { |i| [i, i.to_i] }
      end
      
    end
    
    
  end
  
end
