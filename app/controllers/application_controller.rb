class ApplicationController < ActionController::Base
  before_action :set_current_user_fournisseur

  private

  def set_current_user_fournisseur
    @current_user_fournisseur = Fournisseur.find_by(user_id: current_user.id) if user_signed_in?
  end
end
