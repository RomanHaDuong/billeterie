class BookingsController < ApplicationController
  before_action :authenticate_user!

  def show
    @booking = Booking.find(params[:id])
  end

  def index
    @bookings = current_user.bookings.includes(:offre).order(created_at: :desc)
  end


  def new
    @offre = Offre.find(params[:id])
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.user = current_user
    current_user.name = @booking.user_name
    current_user.save

    if @booking.save
      EventMailer.calendar_invitation(@booking).deliver_now
      redirect_to @booking, notice: 'Réservation confirmée!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy

    redirect_to user_path(current_user), notice: 'Votre réservation a été annulée.'
  end

  def book_event
    booking = Booking.create!(user: current_user, event: @event)
    calendar_event = CalendarService.new(current_user, @event).create_calendar_event
    booking.update(calendar_event_id: calendar_event.id)
    redirect_to @event, notice: 'Booking confirmed! Check your email for calendar invite.'
  end

  private

  def booking_params
    params.require(:booking).permit(:user_name, :user_email, :offre_id)
  end
end
