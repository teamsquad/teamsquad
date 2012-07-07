class ApplicationController < ActionController::Base
  
  protect_from_forgery

protected

  def throw404
    raise ActionController::RoutingError.new('Not Found')
  end

  def throw500
    # ?
  end

  # def rescue_action_in_public(exception) 
  #   case exception 
  #     when ActiveRecord::RecordNotFound, ActionController::UnknownController, ActionController::UnknownAction 
  #       throw404
  #     when ActiveRecord::StatementInvalid
  #       throw404 # Hmmm!
  #     else 
  #       throw500
  #   end 
  # end

end