class Public::OrganisationController < PublicController
  
  before_filter :get_organisation
  
  def login
		render_text 'Not implemented' and return
	end
	
	def admin
		render_text 'Not implemented' and return
	end
		
	def teams
		@teams = @organisation.teams
		@title = "#{@title} - Teams"
	end
	
	def information
		@pages = @organisation.pages
		if @params["page_slug"]
			@page  = @pages.collect.find { |page| page.to_param == @params["page_slug"].downcase }
			throw404 and return unless @page
			@title += " - #{@page.title}"
			@heading = @page.title
			@content = @page.content
			@picture = @page.picture
			@main    = false
		else
			@title   += ' - Information'
			@heading = 'Information'
			@content = @organisation.summary
			@picture = false
			@main    = true
		end
	end
	
	def notices
		@notices = @organisation.notices
		@title = "#{@title} - Notices"
	end

	#
	# SPECIFIC NOTICE
	#
	
	before_filter :get_notice,
	  :only => [:notice, :commented]
	
	# Display a specific notice and handle comment form for it.
	def notice
		@comments = @notice.comments
		@comment = Comment.new @params["comment"]
		@comment.notice_id = @notice.id
		if @request.post? && @comment.save
			redirect_to :action => 'commented' and return
		end
		@notices = @organisation.recent_notices
	end
	
	# Where you end up if you successfully post a comment.
	def commented
		@title = "Thanks for your comments"
	end
	
end
