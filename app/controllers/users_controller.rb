class UsersController < ApplicationController
  def show
    @offres_inscrit = Booking.where(user_id: current_user.id).map(&:offre)
    @favoris = Favori.where(user_id: current_user.id).map(&:offre)
  end
end
