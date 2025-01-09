class FournisseursController < ApplicationController
# In your controller
  def index
    @fournisseurs = Fournisseur.all.order(:name)
  end


  def new
    @fournisseur = Fournisseur.new(user_id: current_user.id)
  end

  def create
    @fournisseur = Fournisseur.new(fournisseur_params)
    if @fournisseur.save
      redirect_to fournisseur_path(@fournisseur)
    else
      render :new
    end
  end

  def show
    @fournisseur = Fournisseur.find(params[:id])
    @offres = Offre.where(fournisseur_id: @fournisseur.id)
    @all_offres = @fournisseur.offres + @fournisseur.secondary_offres
  end

  def your_profile
    @fournisseur = Fournisseur.find_by(user_id: current_user.id)
    @offres = Offre.where(fournisseur_id: @fournisseur.id)
  end

  private

  def fournisseur_params
    params.require(:fournisseur).permit(:bio, :user_id, :name)
  end
end
