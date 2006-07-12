class InformationController < AbstractAccountController
  
  before_filter :check_logged_in, :only => [:new, :edit]
  
  def index
    @pages   = @organisation.pages
    @titles  << 'Information'
  end
  
  def view
    @pages   = @organisation.pages
    @page    = @organisation.find_page(@params[:page])
    @titles << @page.title
  end
  
  def new
    @titles << 'New page'
    @form = Page.new(@params[:form])
    @form.organisation_id = @organisation.id
    if @request.post? and @form.save
      redirect_to information_page_url(:page => @form) and return
    end
  end
  
  def edit
    @titles << 'Edit page'
    @form = @organisation.find_page(@params[:page])
    if @request.post? and @form.update_attributes(@params[:form])
      redirect_to information_page_url(:page => @form) and return
    end
  end

end
