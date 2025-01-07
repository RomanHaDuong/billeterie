class FavorisController < ApplicationController
  before_action :authenticate_user!

  def index
    @offres = Favori.where(user_id: current_user.id).map(&:offre)
  end

  def new
    @favori = Favori.new
  end

  def create
    @offre = Offre.find(params[:offre_id])
    @favori = current_user.favoris.create(offre: @offre)
    redirect_back(fallback_location: offres_path)
  end

  def destroy
    @offre = Offre.find(params[:offre_id])
    @favori = current_user.favoris.find_by(offre: @offre)
    @favori.destroy if @favori
    redirect_back(fallback_location: offres_path)
  end
end
