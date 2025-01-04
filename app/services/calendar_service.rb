class CalendarService
  def initialize(user, event)
    @user = user
    @event = event
  end

  def create_calendar_event
    client = Google::Apis::CalendarV3::CalendarService.new
    client.authorization = @user.google_token

    event = Google::Apis::CalendarV3::Event.new(
      summary: @event.title,
      location: @event.location,
      description: @event.description,
      start: {
        date_time: @event.start_time.iso8601
      },
      end: {
        date_time: @event.end_time.iso8601
      },
      attendees: [
        {email: @user.email}
      ]
    )

    client.insert_event('primary', event)
  end
end
