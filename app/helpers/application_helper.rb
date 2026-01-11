module ApplicationHelper
  def format_time_french(datetime)
    return '' unless datetime
    
    if datetime.min.zero?
      datetime.strftime("%H:00")
    else
      datetime.strftime("%H:%M")
    end
  end
end
