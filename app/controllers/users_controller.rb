class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @favoris = current_user.favoris.includes(:offre).order(created_at: :desc)
    @offres = @favoris.map(&:offre).sort_by(&:date_prevue)
  end

  def edit
    @user = current_user
    @fournisseur = current_user.fournisseur if current_user.intervenant?
  end

  def update
    @user = current_user
    @fournisseur = current_user.fournisseur if current_user.intervenant?
    
    if @user.update(user_params)
      # Also update fournisseur if user is an intervenant
      if @fournisseur && params[:fournisseur]
        @fournisseur.update(fournisseur_params)
      end
      redirect_to dashboard_path, notice: 'Profil mis à jour avec succès'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :image)
  end

  def fournisseur_params
    params.require(:fournisseur).permit(:name, :bio, :instagram, :linkedin, :offinity, :image)
  end
end
