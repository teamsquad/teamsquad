class SeasonController < AbstractAccountController

  before_filter :check_logged_in, :only => [:edit]

  def edit
    get_season
    @form = @season.dup
    if request.post? && @form.update_attributes(params[:form])
      redirect_to home_url 
    end
  end

end
