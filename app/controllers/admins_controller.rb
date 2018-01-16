class AdminsController < ApplicationController
  before_action :require_user
  before_action :require_admin

  private

  def require_admin
    if !current_user.admin?
      flash[:error] = "You are not allowed to access this page."
      redirect_to home_path
    end
  end
end