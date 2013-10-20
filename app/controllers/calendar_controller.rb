class CalendarController < AbstractAccountController
  
  before_filter :get_competition
  
  def index
    @titles << "Calendar"
    date = params['date'] || Date.new
    @dates = Array.new
    @competition.match_days.each { |d| @dates << Date.new( d.date.year, d.date.month, d.date.day ) }
    @months = @competition.match_months
  end
  
  def year
    @titles << params[:year]
  end
  
  def month
    @date = Date.new( params[:year].to_i, params[:month].to_i, 1 )
    @titles << params[:year]
    @titles << @date.strftime('%B')
  end
  
  def day
    @date = Date.new( params[:year].to_i, params[:month].to_i, params[:day].to_i )
    @titles << params[:year]
    @titles << @date.strftime('%B')
    @titles << params[:day].to_i
  end

end
