class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @bookings = current_user.bookings.includes(:offre).order(created_at: :desc)
    @offres = @bookings.map(&:offre).sort_by(&:date_prevue)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'Profile updated successfully'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :image)
  end
end
