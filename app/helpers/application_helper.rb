# The methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	
	def safely_display(source)
		result = source
		simple_format(auto_link(CGI.escapeHTML(result))) 
	end
	
end
