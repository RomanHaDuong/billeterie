class FournisseursController < ApplicationController
  def index
    @fournisseurs = Fournisseur.where.not(name: nil).order(:name)
    no_render = Fournisseur.find_by(name: "Isabelle Forestier, Lucille Couturier, Prisca Elizabeth")
    alex = Fournisseur.find_by(name: "Alexandra Gautrand Ha Duong")
    @fournisseurs = @fournisseurs - [no_render]
    @fournisseurs = @fournisseurs - [alex]

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
