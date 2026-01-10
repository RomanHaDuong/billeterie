class PagesController < ApplicationController
  def home
    # Homepage for the Festival du 47 (current edition)
    @offres = Offre.all.order(date_prevue: :asc)
  end

  def home_2025
    # 2025 edition homepage
    @offres = Offre.all.order(date_prevue: :asc)
    render 'home_2025'
  end

  def lieu
  end

  def lieu_2025
    render 'lieu_2025'
  end

  def payment
  end

  def legal
  end

  def profile
  end

  def participation
  end
end
