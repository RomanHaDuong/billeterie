class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @bookings = current_user.bookings.includes(:offre).order(created_at: :desc)
    @offres = Favori.where(user_id: current_user.id).map(&:offre)
  end
end
