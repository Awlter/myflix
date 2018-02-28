class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def new_with_token
    invitation = Invitation.find_by(token: params[:token])

    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  def show
    @user = User.find_by(token: params[:id])
    @relationship = Relationship.find_by(follower:current_user, leader: @user)
  end

  def create
    @user = User.new(user_params)
    result = UserCreation.new(@user, params[:invitation_token]).create(params[:stripeToken])

    if result.successful?
      flash[:notice] = "Succeeded! Thanks for your registration."
      redirect_to sign_in_path
    else
      flash.now[:error] = result.error_message
      render :new
    end
  end

  def edit
    @user = User.find_by(token: params[:id])
  end

  def update
    @user = User.find_by(token: params[:id])
    if @user.update(user_params)
      flash[:notice] = 'Your account has been updated.'
      redirect_to user_path(@user)
    else
      flash[:danger] = 'There was a problem updating your account. Please try again.'
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end
end