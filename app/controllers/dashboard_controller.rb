class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @registered_offres = current_user.bookings.includes(:offre).map(&:offre).sort_by { |o| o.date_prevue || DateTime::Infinity.new }
    @my_offres = current_user.my_offres.order(date_prevue: :asc) if current_user.intervenant?
  end
end
