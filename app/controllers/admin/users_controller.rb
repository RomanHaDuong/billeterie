class Admin::UsersController < ApplicationController
  layout 'application'
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @users = User.all.order(created_at: :desc)
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

  private

  def require_admin
    unless current_user.admin?
      redirect_to root_path, alert: "Accès refusé"
    end
  end
end
