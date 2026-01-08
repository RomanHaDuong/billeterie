class Archive2025::OffresController < Archive2025::BaseController
  def index
    @offres = Offre.all.order(date_prevue: :asc)
  end

  def show
    @offre = Offre.find(params[:id])
    @fournisseur = @offre.fournisseur
    @secondary_fournisseur = Fournisseur.find_by(id: @offre.secondary_fournisseur_id) if @offre.secondary_fournisseur_id.present?
  end
end
