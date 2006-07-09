class HelpController < AbstractAccountController

  before_filter :set_title

  def index
  end
  
  def formatting_text
    @titles << 'Formatting text'
  end

private

  def set_title
    @titles << 'Help'
  end
  
end
