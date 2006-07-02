# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def safely_display(source)
		result = source
		simple_format(auto_link(CGI.escapeHTML(result))) 
	end
	
	# Called by rhtml pagelet to render a complete form field
  def form_field(model, fieldtype, fieldname, label)
    render_partial(
      "/partials/formfield",
      model,
      "fieldtype" => fieldtype,
      "name" => fieldname,
      "label" => label
    )
  end
  
  # Called from within formfield partial to generate input element
  def form_input(fieldtype, modelname, fieldname)
    case fieldtype
      when "text"
        text_field modelname, fieldname
      when "password"
        password_field modelname, fieldname
      when "textarea"
        text_area modelname, fieldname, "rows" => 5, "cols" => 30
      when "submit"
        submit modelname, fieldname
    end
  end
  

end
