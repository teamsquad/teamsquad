class AjaxController < ApplicationController

  def textile_preview
    @source = params[:form][:content] || ''
  end

end
