class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers
  before_action :set_current_user_fournisseur
  before_action :configure_permitted_parameters, if: :devise_controller?

  def toggle_edit_mode
    if current_user&.admin?
      session[:edit_mode] = !session[:edit_mode]
      render json: { edit_mode: session[:edit_mode] }
    else
      head :forbidden
    end
  end

  private

  def set_current_user_fournisseur
    return unless current_user.present? && current_user.respond_to?(:id)
    @current_user_fournisseur = Fournisseur.find_by(user_id: current_user.id)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar])
  end
end
