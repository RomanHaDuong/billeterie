class PagesController < ApplicationController
  def home
    @offres = Offre.all.order(date_prevue: :asc)
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
