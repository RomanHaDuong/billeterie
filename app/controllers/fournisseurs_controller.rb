class FournisseursController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  
  def index
    @fournisseurs = Fournisseur.where.not(name: nil)
      .joins(:offres)
      .distinct
      .order(:name)
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

    @all_offres = (@fournisseur.offres + @fournisseur.secondary_offres).sort_by(&:date_prevue)
  end

  def your_profile
    @fournisseur = Fournisseur.find_by(user_id: current_user.id)
    @offres = Offre.where(fournisseur_id: @fournisseur.id)
  end

  private

  def fournisseur_params
    params.require(:fournisseur).permit(:bio, :name, :instagram, :linkedin, :offinity, :image)
  end
end
