module ApplicationHelper
  def format_time_french(datetime)
    return '' unless datetime
    
    if datetime.min.zero?
      datetime.strftime("%Hh")
    else
      datetime.strftime("%Hh%M")
    end
  end
end
