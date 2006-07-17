# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
class ApplicationController < ActionController::Base

  include BrowserFilters

protected

  def throw404
    render_404 # simple wrapper round plugin to insulate it
  end

  def throw500
    render_500 # simple wrapper round plugin to insulate it
  end

  def rescue_action_in_public(exception) 
    case exception 
      when ActiveRecord::RecordNotFound, ActionController::UnknownController, ActionController::UnknownAction 
        throw404
      when ActiveRecord::StatementInvalid
        throw404 # Hmmm!
      else 
        throw500
        deliverer = self.class.exception_data
        data = case deliverer
          when nil then {}
          when Symbol then send(deliverer)
          when Proc then deliverer.call(self)
        end

        ExceptionNotifier.deliver_exception_notification(exception, self,
          request, data)
    end 
  end

end