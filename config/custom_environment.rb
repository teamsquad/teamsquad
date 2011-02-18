# UTF-8 suppport...
$KCODE = 'u'
require_dependency 'jcode'
ExceptionNotifier.exception_recipients = %w(stephen@latterfamily.com)


# Fix for Ruby 1.8.7
class String
  def chars
    ActiveSupport::Multibyte::Chars.new(self)
  end
  alias_method :mb_chars, :chars
end