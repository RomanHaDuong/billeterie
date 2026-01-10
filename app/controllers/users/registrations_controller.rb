# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :store_return_to, only: [:new]

  private

  def store_return_to
    if params[:return_to].present?
      session[:user_return_to] = params[:return_to]
    end
  end
end
