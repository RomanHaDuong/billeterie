class Archive2025::PagesController < Archive2025::BaseController
  def home
    @offres = Offre.all.order(date_prevue: :asc)
  end

  def lieu
  end
end
