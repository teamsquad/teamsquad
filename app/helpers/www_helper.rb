module WwwHelper
  
	# Called by rhtml pagelet to render a complete form field
  def form_field(model, fieldtype, fieldname, label, postfix = nil)
    render :partial => "/partials/formfield",
           :object => model,
           :locals => {
              :fieldtype => fieldtype,
              :name => fieldname,
              :label => label,
              :postfix => postfix
          }
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
