class FournisseursController < ApplicationController
  def new
    @fournisseur = Fournisseur.new
  end

  def create
    @fournisseur = Fournisseur.new(fournisseur_params)
  end

  def show
    @fournisseur = Fournisseur.find_by(user_id: current_user.id)
  end

  private

  def fournisseur_params
    params.require(:fournisseur).permit(:bio, :user_id, :name)
  end
end
