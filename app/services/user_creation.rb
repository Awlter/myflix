class UserCreation
  attr_reader :user, :invitation_token, :error_message

  def initialize(user, invitation_token)
    @user = user
    @invitation_token = invitation_token
  end

  def create(stripe_token)
    if user.valid?
      charge = StripeWrapper::Charge.create(amount: 999, card: stripe_token)

      if charge.successful?
        user.save
        handle_invitation
        MyMailer.delay.register_success_mail(user)
        @status = :success
      else
        @error_message = charge.error_message
        @status = :error
      end
    else
      @status = :error
      @error_message = "The user information are not valid. Please check them below"
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