# The methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	
	def safely_display(source)
		result = source
		result.gsub!(/&/, '&amp;')
		result.gsub!(/>/, '&gt;')
		result.gsub!(/</, '&lt;')
		simple_format(auto_link(result)) 
	end
	
end
