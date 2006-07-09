class AjaxController < ApplicationController

  def textile_preview
    @source = params[:form][:content] || ''
  end
  
  def textile_html
    @source = params[:form][:content] || ''
  end
  
end
