class PagesController < ApplicationController
  def home
    # New homepage for the Festival du 47
    render 'new_home'
  end

  def old_home
    # Old edition 2025 homepage
    @offres = Offre.all.order(date_prevue: :asc)
    render 'home'
  end

  def lieu
  end

  def payment
  end

  def legal
  end

  def profile
  end
end
