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

    if @user.valid?
      charge = StripeWrapper::Charge.create(amount: 999, card: params[:stripeToken])

      if charge.successful?
        UserCreation.new(@user, params[:invitation_token]).act
        redirect_to sign_in_path
      else
        flash.now[:error] = charge.error_message
        render :new
      end
    else
      flash.now[:error] = "Invalid user information. Please check the errors below."
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end
end