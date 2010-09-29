module ActionView
  module Helpers
    class FormBuilder
      
      def first_error_for(method)
        error = Array(@object.errors.on(method)).first
        @template.content_tag(:span, error, :class => :error_message) if error.present?
      end
      
    end
  end
end
