class WwwController < ApplicationController
  
  def index
    @organisations = Organisation.find(:all, :limit => 10, :order => 'created_on desc')
  end
  
  def about
    
  end
  
  def privacy
    
  end
  
  def disclaimer
    
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
