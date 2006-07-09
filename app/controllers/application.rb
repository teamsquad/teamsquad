# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
class ApplicationController < ActionController::Base

  include BrowserFilters

  def throw404
    redirect_to('/404.html')
  end

end