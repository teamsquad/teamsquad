# UTF-8 suppport...
$KCODE = 'u'
require_dependency 'jcode'

# handy extra bits and bobs...
require_dependency 'transforms'

ExceptionNotifier.exception_recipients = %w(stephen@latterfamily.com)
