class FournisseursController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  
  def index
    # Get fournisseurs who have any type of offres (primary, secondary, or additional)
    primary_animateurs = Fournisseur.where.not(name: nil).joins(:offres).distinct
    secondary_animateurs = Fournisseur.where.not(name: nil).joins(:secondary_offres).distinct
    additional_animateurs = Fournisseur.where.not(name: nil).joins(:additional_offres).distinct
    
    # Combine all unique fournisseurs
    @fournisseurs = (primary_animateurs + secondary_animateurs + additional_animateurs).uniq.sort_by(&:name)
    
    no_render = Fournisseur.find_by(name: "Isabelle Forestier, Lucille Couturier, Prisca Elizabeth")
    alex = Fournisseur.find_by(name: "Alexandra Gautrand Ha Duong")
    @fournisseurs = @fournisseurs - [no_render]
    @fournisseurs = @fournisseurs - [alex]

  end


  def new
    if current_user&.intervenant?
      redirect_to dashboard_path, alert: "Vous êtes déjà intervenant."
      return
    end
    @fournisseur = Fournisseur.new
  end

  def create
    if current_user&.intervenant?
      redirect_to dashboard_path, alert: "Vous êtes déjà intervenant."
      return
    end
    
    @fournisseur = Fournisseur.new(fournisseur_params)
    @fournisseur.user = current_user
    
    # Use user's profile image if no image is provided for fournisseur
    if !params[:fournisseur][:image].present? && current_user.image.attached?
      @fournisseur.image.attach(current_user.image.blob)
    end
    
    if @fournisseur.save
      redirect_to dashboard_path, notice: "Félicitations ! Vous êtes maintenant intervenant. Vous pouvez créer vos ateliers."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @fournisseur = Fournisseur.find(params[:id])
    @offres = Offre.where(fournisseur_id: @fournisseur.id).order(:date_prevue)

    @all_offres = (@fournisseur.offres + @fournisseur.secondary_offres + @fournisseur.additional_offres).uniq.sort_by(&:date_prevue)
  end

  def your_profile
    @fournisseur = Fournisseur.find_by(user_id: current_user.id)
    @offres = Offre.where(fournisseur_id: @fournisseur.id)
  end

  def edit
    @fournisseur = Fournisseur.find(params[:id])
    unless current_user&.admin? || (current_user.intervenant? && current_user.fournisseur.id == @fournisseur.id)
      redirect_to dashboard_path, alert: "Vous n'avez pas la permission de modifier ce profil."
    end
  end

  def update
    @fournisseur = Fournisseur.find(params[:id])
    unless current_user&.admin? || (current_user.intervenant? && current_user.fournisseur.id == @fournisseur.id)
      redirect_to dashboard_path, alert: "Vous n'avez pas la permission de modifier ce profil."
      return
    end

    # Handle image upload - attach to the fournisseur's user instead of the fournisseur
    if params[:fournisseur][:image].present? && @fournisseur.user.present?
      @fournisseur.user.image.attach(params[:fournisseur][:image])
    end

    # Remove image from params since we're handling it separately
    fournisseur_update_params = fournisseur_params.except(:image)

    if @fournisseur.update(fournisseur_update_params)
      redirect_to edit_fournisseur_path(@fournisseur), notice: "Profil intervenant mis à jour avec succès!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def fournisseur_params
    params.require(:fournisseur).permit(:bio, :name, :instagram, :linkedin, :offinity, :image)
  end
end
