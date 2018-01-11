class UserCreation
  attr_reader :user, :invitation_token, :error_message

  def initialize(user, invitation_token)
    @user = user
    @invitation_token = invitation_token
  end

  def create(stripe_token)
    if user.valid?
      customer = StripeWrapper::Customer.create(email: user.email, card: stripe_token)

      if customer.successful?
        user.save
        handle_invitation
        MyMailer.delay.register_success_mail(user)
        @status = :success
      else
        @error_message = customer.error_message
        @status = :error
      end
    else
      @status = :error
      @error_message = "Invalid user information. Please check the errors below."
    end

    self
  end

  def successful?
    @status == :success
  end

  private

  def handle_invitation
    if invitation_token.present?
      invitation = Invitation.find_by(token: invitation_token)
      invitation.inviter.follow(user)
      user.follow(invitation.inviter)
      invitation.update_column(:token, nil)
    end
  end
end