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
        self.value =
            begin
              value.first.content.to_date
            rescue
              ::Date.new(::Date.send(:now).year, ::Date.send(:now).month, 1).strftime("%Y-%m-%d")
            end
      end
      
      def tag
        :text_field
      end
      
      def options_for_tag
        { :"data-format" => "calendar", :style => "display: none;" }
      end
      
    end

    module From
      include Infosell::XMLFormElementValue::Date

      def parse
        self.value =
            begin
              value.first.content.to_date
            rescue
              two_months_ago = ::Date.send(:now) - 2.months
              ::Date.new(two_months_ago.year, two_months_ago.month, 1).strftime("%Y-%m-%d")
            end
      end

      def options_for_tag
        { :"data-format" => "month-calendar", :style => "display: none;" }
      end
    end

    module Till
      include Infosell::XMLFormElementValue::Date

      def parse
        self.value =
            begin
              value.first.content.to_date
            rescue
              month_ago = ::Date.send(:now) - 1.month
              ::Date.new(month_ago.year, month_ago.month, 1).strftime("%Y-%m-%d")
            end
      end

      def options_for_tag
        { :"data-format" => "month-calendar", :style => "display: none;" }
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
