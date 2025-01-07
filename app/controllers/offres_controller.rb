class OffresController < ApplicationController
  def index
    @offres = Offre.all.order(date_prevue: :asc)
  end

  def show
    @offre = Offre.find(params[:id])
    @booking = Booking.new
  end
end
