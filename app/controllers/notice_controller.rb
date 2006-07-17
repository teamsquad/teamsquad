class NoticeController < AbstractAccountController

  before_filter :check_logged_in, :only => [:new, :edit, :moderate]
  
  def index
    @titles << 'Notices'
  end
  
  def view
    get_notice or return
    @comment = Comment.new params["comment"]
    @comment.notice = @notice
    if request.post? && @comment.save
      redirect_to commented_url(:notice => @notice) and return
    end
  end
  
  def new
    @titles << 'New notice'
    @form = @organisation.notices.build(params[:form])
    @form.author          = current_user
    if request.post? && @form.save
      redirect_to notice_url(:notice => @form) and return
    end
  end
  
  def edit
    get_notice or return
    @form = @notice
    @titles << 'Edit'
    if request.post? and @form.update_attributes(params[:form])
      redirect_to notice_url(:notice => @form) and return
    end
  end
  
  def commented
    get_notice or return
    @titles << 'Comment taken'
  end
  
  def moderate
    get_notice or return
    @titles << @notice.heading
    @titles << "Comment moderation"
    @comments = @notice.comments
    if request.post? and @notice.moderate_comments(params)
      redirect_to notice_url(:notice => @notice) and return
    end
  end
  
end
