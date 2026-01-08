class Archive2025::FournisseursController < Archive2025::BaseController
  def index
    @fournisseurs = Fournisseur.all
  end

  def show
    @fournisseur = Fournisseur.find(params[:id])
    @offres = @fournisseur.offres
  end
end
