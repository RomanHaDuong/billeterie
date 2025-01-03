class BookingsController < ApplicationController
  def index
    @bookings = Booking.where(user_id: current_user.id)
  end

  def new
    @booking = Booking.new
    @offre = Offre.find(params[:offre_id])
  end

  def create
    @booking = Booking.new(booking_params)
    @offre = Offre.find(params[:offre_id])
    @booking.offre = @offre
    @booking.user = current_user
    @booking.creneau = params[:creneau]
    if @booking.save
      redirect_to bookings_path
    else
      render :new
    end
  end

  def book_event
    booking = Booking.create!(user: current_user, event: @event)
    calendar_event = CalendarService.new(current_user, @event).create_calendar_event
    booking.update(calendar_event_id: calendar_event.id)
    redirect_to @event, notice: 'Booking confirmed! Check your email for calendar invite.'
  end

  private

  def booking_params
    params.require(:booking).permit(:date)
  end
end
