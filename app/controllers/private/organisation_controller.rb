class Private::OrganisationController < Private::AbstractController
  
  before_filter :get_organisation
  
  def new_team
	  @title = "#{@title} - Add team"
		@team = Team.new(@params["team"])
		@team.organisation_id = @organisation.id
		if @request.post? and @team.save
			redirect_to :controller => '/public/organisation', :action => 'teams' and return
		end
	end
	
	def new_page
	  @title = "#{@title} - Add page"
		@page = Page.new()
		@page.organisation_id = @organisation.id
		if @request.post? and @page.save_from_params(@params[:page])
		  redirect_to :controller => '/public/organisation', :action => 'information', :page_slug => @page and return
		end
	end
	
	def edit_page
		@page = @organisation.find_page_by_url_slug @params["page_slug"]
		throw404 and return unless @page
		@title = "#{@title} - #{@page.title}"
		if @request.post? and @page.save_from_params(@params[:page])
			redirect_to :controller => '/public/organisation', :action => 'information', :page_slug => @page and return
		end
	end
	
	def new_notice
	  @title = "#{@title} - Add notice"
		@notice = Notice.new()
		@notice.user_id = 1 # TODO: should be current logged in user
		@notice.organisation_id = @organisation.id
		if @request.post? and @notice.save_from_params(@params[:notice])
		  redirect_to :controller => '/public/organisation', :action => 'home' and return
		end
	end
  
  
  #
  # SPECIFIC NOTICE
  #
  
  before_filter :get_notice,
    :only => [:edit_notice, :edit_comments]
  
  # Alter a pre-existing notice
	def edit_notice
		if @request.post? and @notice.save_from_params(@params[:notice])
		  redirect_to :controller => '/public/organisation', :action => 'notice', :page_slug => @notice and return
		end
	end
	
	# Display and handle moderation of existing comments for a notice.
	def edit_comments
		@comments = @notice.comments
		if @request.post? and @notice.moderate_comments(params)
			redirect_to :controller => '/public/organisation', :action => 'notices' and return
		end
	end

end
