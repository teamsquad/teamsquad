# UTF-8 suppport...
$KCODE = 'u'
require_dependency 'jcode'

# handy extra bits and bobs...
require_dependency 'transforms'

ExceptionNotifier.exception_recipients = %w(stephen@latterfamily.com)

# Hack to avoid form helpers adding a DIV around fields with errors.
# We don't want them damn it!
module ActionView
  class Base
    @@field_error_proc = Proc.new{ |html_tag, instance| "<span class=\"problem\">#{html_tag}</span>" }
    cattr_accessor :field_error_proc
  end
end