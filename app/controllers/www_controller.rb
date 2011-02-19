class WwwController < ApplicationController
  
  def index

  end
  
  def about
    
  end
  
  def privacy
    
  end
  
  def disclaimer
    
  end
  
  def version
  
  end
  
  def features
    
  end
  
  def contact
    @page_title = "Contact"
    @contactresponse = ContactResponse.new(params["contactresponse"])
    if request.post? && @contactresponse.save
      redirect_to(:action => "contacted") and return
    end
  end
  
  def contacted
  
  end
   
  def search
    @organisations = Organisation.find(:all)
  end
  
  def register
    @organisation = Organisation.new(params["organisation"])
    @user         = User.new(params["user"])
    @invite       = Invite.new(params["invite"])
    if request.post? && Organisation.register(@organisation, @user, @invite)
      redirect_to(:action => "registered", :id => @organisation.id) and return
    end
    @page_title = "Register"
    @sports = Sport.find(:all)
  end
  
  def registered
    @organisation = Organisation.find(params["id"])
  end
  
end
