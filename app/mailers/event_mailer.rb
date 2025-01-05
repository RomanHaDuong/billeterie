# app/mailers/event_mailer.rb
class EventMailer < ApplicationMailer
  def calendar_invitation(booking)
    @booking = booking
    @offre = booking.offre

    calendar = create_calendar_event
    attachments['event.ics'] = {
      mime_type: 'text/calendar',
      content: calendar.to_ical
    }

    mail(
      to: @booking.user_email,
      subject: "Invitation: #{@offre.titre}"
    )
  end

  private

  def create_calendar_event
    cal = Icalendar::Calendar.new
    event = Icalendar::Event.new
    event.dtstart = @offre.date_prevue
    # event.dtend = @offre.date_prevue + @offre.duree.hours
    event.summary = @offre.titre
    event.description = @offre.descriptif
    event.location = "47 boulevard de Sébastopol, 75001 Paris"
    cal.add_event(event)
    cal
  end
end
