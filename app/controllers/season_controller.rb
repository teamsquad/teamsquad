class SeasonController < AbstractAccountController

  before_filter :check_logged_in, :only => [:edit]

  def archive
    @titles << "Archive"
  end
  
  def view
    get_season
    @titles << @season.title
  end

  def edit
    get_season
    @form = params[:form] || @season.dup
    if request.post? && @season.update_attributes(params[:form])
      redirect_to home_url 
    end
  end

end
