class WwwController < ApplicationController
  
  def index

  end
  
  def about
    
  end
  
  def privacy
    
  end
  
  def disclaimer
    
  end
  
  def alpha
  
  end
  
  def screenshots
    
  end
  
  def contact
    @page_title = "Contact"
    @contactresponse = ContactResponse.new(params["contactresponse"])
    if @request.post? && @contactresponse.save
      redirect_to :action => "contacted"
    end
  end
  
  def contacted
  
  end
   
  def search
    @organisations = Organisation.find(:all)
  end
  
  def register
    @page_title = "Register"
    @user = User.new(params["user"])
    @organisation = Organisation.new(params["organisation"])
    @sports = Sport.find_all
    if @request.post? && do_registration(@user, @organisation)
      redirect_to :action => "registered", :id => @organisation.id
    end
  end
  
  def registered
    @organisation = Organisation.find(params["id"])
  end

private

  # Hmm, should probably be inside the organisation model
  def do_registration(user, organisation)
    begin
      Organisation.transaction do
        user_saved = @user.save
        organisation_saved = @organisation.save
        raise 'Argh' unless user_saved && organisation_saved
      end
      true
    rescue
      false
    end
  end
  
end
