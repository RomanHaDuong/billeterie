class OffresController < ApplicationController
  before_action :authenticate_user!, only: [:register, :unregister, :new, :create, :edit, :update, :destroy]
  before_action :set_offre, only: [:show, :register, :unregister, :edit, :update, :destroy]
  before_action :check_ownership, only: [:edit, :update, :destroy]

  def index
    @offres = Offre.all.order(date_prevue: :asc)
  end

  def show
    @booking = Booking.new
    @is_owner = current_user && current_user.intervenant? && 
                (current_user.fournisseur.id == @offre.fournisseur_id || 
                 current_user.fournisseur.id == @offre.secondary_fournisseur_id ||
                 @offre.additional_fournisseurs.pluck(:id).include?(current_user.fournisseur.id))
  end

  def new
    unless current_user.intervenant?
      redirect_to dashboard_path, alert: "Vous devez être intervenant pour créer un atelier."
      return
    end
    @offre = Offre.new
  end

  def create
    unless current_user.intervenant?
      redirect_to dashboard_path, alert: "Vous devez être intervenant pour créer un atelier."
      return
    end

    @offre = current_user.fournisseur.offres.build(offre_params)
    
    if @offre.save
      redirect_to @offre, notice: "Atelier créé avec succès!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @offre.update(offre_params)
      redirect_to @offre, notice: "Atelier mis à jour avec succès!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @offre.destroy
    redirect_to dashboard_path, notice: "Atelier supprimé avec succès!"
  end

  def register
    if @offre.full?
      redirect_to @offre, alert: "Désolé, cet atelier est complet."
      return
    end

    if @offre.user_registered?(current_user)
      redirect_to @offre, notice: "Vous êtes déjà inscrit à cet atelier."
      return
    end

    booking = @offre.bookings.build(user: current_user, status: 'confirmed')
    
    if booking.save
      redirect_to @offre, notice: "Inscription réussie ! Vous êtes maintenant inscrit à cet atelier."
    else
      redirect_to @offre, alert: "Une erreur s'est produite lors de l'inscription."
    end
  end

  def unregister
    booking = @offre.bookings.find_by(user: current_user)
    
    if booking
      booking.destroy
      redirect_to @offre, notice: "Vous êtes désinscrit de cet atelier."
    else
      redirect_to @offre, alert: "Vous n'êtes pas inscrit à cet atelier."
    end
  end

  private

  def set_offre
    @offre = Offre.find(params[:id])
  end

  def check_ownership
    return if current_user&.admin?
    
    unless current_user.intervenant? && 
           (current_user.fournisseur.id == @offre.fournisseur_id || 
            current_user.fournisseur.id == @offre.secondary_fournisseur_id ||
            @offre.additional_fournisseurs.pluck(:id).include?(current_user.fournisseur.id))
      redirect_to @offre, alert: "Vous n'avez pas la permission de modifier cet atelier."
    end
  end

  def offre_params
    params.require(:offre).permit(:titre, :sous_titre, :descriptif, :duree, :place, 
                                  :date_prevue, :salle, :categories, :causes, 
                                  :valeur_apportee, :besoin_espace, :besoin_logistique, 
                                  :autre_commentaire, :secondary_fournisseur_id, :image,
                                  additional_fournisseur_ids: [])
  end
end
