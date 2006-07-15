class ControlPanelController < AbstractAccountController

  before_filter :check_logged_in

  def index
    @titles << "Control panel"
  end
  
  def admins
    @titles << "Administrators"
    @admins = @organisation.users
  end
  
  def new_admin
    @titles << "Administrators"
    @titles << "New"
    @form = @organisation.users.build(params[:form])
    if request.post? && @form.save
      redirect_to control_panel_url(:action => 'admins') 
    end
  end

  def edit_admin
    @titles << "Administrators"
    @titles << "Edit"
    @form = @organisation.users.find(params[:id])
    if request.post? && @form.update_attributes(params[:form])
      redirect_to control_panel_url(:action => 'admins') 
    end
  end

end
