# Hack to avoid form helpers adding a DIV around fields with errors.
# We don't want them damn it!
module ActionView
  class Base
    @@field_error_proc = Proc.new{ |html_tag, instance| "<span class=\"problem\">#{html_tag}</span>" }
    cattr_accessor :field_error_proc
  end
end

# same as above but for error messages.
module ActionView
  module Helpers
    module ActiveRecordHelper
      def error_message_on(object, method, prepend_text = "", append_text = "", css_class = "problem")
        if errors = instance_variable_get("@#{object}").errors.get(method)
          content_tag("p", "#{prepend_text}#{errors.is_a?(Array) ? errors.first : errors}#{append_text}", :class => css_class)
        end
      end
    end
  end
end