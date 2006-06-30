class NoticeController < ApplicationController

  def index
    @titles << 'Notices'
  end
  
  def view
    get_notice or return
    @comment = Comment.new @params["comment"]
    @comment.notice = @notice
    if @request.post? && @comment.save
      redirect_to commented_url(:notice => @notice) and return
    end
  end
  
  def new
    @titles << 'New notice'
    @form = @organisation.notices.build(@params[:form])
    @form.author = current_user
    if @request.post? and @form.save
      redirect_to notice_url(:notice => @form) and return
    end
  end
  
  def edit
    get_notice or return
    @form = @notice
    @titles << 'Edit'
    if @request.post? and @form.update_attributes(@params[:form])
      redirect_to notice_url(:notice => @form) and return
    end
  end
  
  def commented
    get_notice or return
    @titles << 'Comment taken'
  end
  

end
