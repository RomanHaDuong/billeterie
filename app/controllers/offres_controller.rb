class OffresController < ApplicationController
  def index
    @offres = Offre.all
  end

  def show
    @offre = Offre.find(params[:id])
    @booking = Booking.new
  end
end
