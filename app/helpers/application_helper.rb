# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper

  def safely_display(source)
    result = source
    simple_format(CGI.escapeHTML(result)) 
  end  
  
  def nofollowify(text)
    text.gsub(/<\s*a\s*(.+?)>/i, '<a \1 rel="nofollow">')
  end

  def strip_html(text)
    attribute_key = /[\w:_-]+/
    attribute_value = /(?:[A-Za-z0-9]+|(?:'[^']*?'|"[^"]*?"))/
    attribute = /(?:#{attribute_key}(?:\s*=\s*#{attribute_value})?)/
    attributes = /(?:#{attribute}(?:\s+#{attribute})*)/
    tag_key = attribute_key
    tag = %r{<[!/?\[]?(?:#{tag_key}|--)(?:\s+#{attributes})?\s*(?:[!/?\]]+|--)?>}
    text.gsub(tag, '').gsub(/\s+/, ' ').strip
  end
  
  def leading_zero_on_single_digits(number)
    number > 9 ? number : "0#{number}"
  end
  
  def error_message_on(object, method, options = {})
    object = convert_to_model(object)
    obj = object.respond_to?(:errors) ? object : instance_variable_get("@#{object}")

    if obj.errors[method].present?
      errors = obj.errors[method].map{|err| h(err)}.join('<br/>').html_safe
      content_tag(:p, errors, :class => 'problem')
    else
      ''
    end
  end

end
