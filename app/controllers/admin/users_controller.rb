class Admin::UsersController < ApplicationController
  layout 'application'
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @users = User.all.order(created_at: :desc)
    @pre_registrations = PreRegistration.all.order(created_at: :desc)
    @pre_registration = PreRegistration.new
  end

  def make_intervenant
    @user = User.find(params[:id])
    if @user.fournisseur.present?
      redirect_to admin_users_path, alert: "Cet utilisateur est déjà intervenant"
    else
      Fournisseur.create!(
        user: @user,
        name: @user.name || @user.email,
        bio: "Intervenant du Festival du 47"
      )
      redirect_to admin_users_path, notice: "#{@user.email} est maintenant intervenant"
    end
  end

  def make_admin
    @user = User.find(params[:id])
    @user.update(admin: true)
    redirect_to admin_users_path, notice: "#{@user.email} est maintenant administrateur"
  end

  def remove_admin
    @user = User.find(params[:id])
    if @user.id == current_user.id
      redirect_to admin_users_path, alert: "Vous ne pouvez pas vous retirer vos propres droits d'admin"
    else
      @user.update(admin: false)
      redirect_to admin_users_path, notice: "Droits d'administrateur retirés pour #{@user.email}"
    end
  end

  def remove_intervenant
    @user = User.find(params[:id])
    if @user.fournisseur.blank?
      redirect_to admin_users_path, alert: "Cet utilisateur n'est pas intervenant"
    elsif @user.my_offres.any?
      redirect_to admin_users_path, alert: "Impossible de retirer le statut intervenant : cet utilisateur a des ateliers"
    else
      @user.fournisseur.destroy
      redirect_to admin_users_path, notice: "Statut intervenant retiré pour #{@user.email}"
    end
  end

  def create_pre_registration
    @pre_registration = PreRegistration.new(pre_registration_params)
    if @pre_registration.save
      redirect_to admin_users_path, notice: "Pré-inscription créée pour #{@pre_registration.email}"
    else
      @users = User.all.order(created_at: :desc)
      @pre_registrations = PreRegistration.all.order(created_at: :desc)
      render :index
    end
  end

  def destroy_pre_registration
    @pre_registration = PreRegistration.find(params[:id])
    @pre_registration.destroy
    redirect_to admin_users_path, notice: "Pré-inscription supprimée"
  end

  private

  def require_admin
    unless current_user.admin?
      redirect_to root_path, alert: "Accès refusé"
    end
  end

  def pre_registration_params
    params.require(:pre_registration).permit(:email, :role)
  end
end
