class ApplicationController < ActionController::Base
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

  # Redirect to stored location or homepage after sign in
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || session.delete(:user_return_to) || root_path
  end

  # Redirect to stored location or homepage after sign up
  def after_sign_up_path_for(resource)
    session.delete(:user_return_to) || root_path
  end

  private

  def set_current_user_fournisseur
    @current_user_fournisseur = Fournisseur.find_by(user_id: current_user.id) if user_signed_in?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:image, :avatar, :name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:image, :avatar, :name])
  end
end
