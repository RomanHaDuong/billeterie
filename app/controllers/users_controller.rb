class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @bookings = current_user.bookings.includes(:offre).order(created_at: :desc)
    @offres = @bookings.map(&:offre).sort_by(&:date_prevue)
  end
end
