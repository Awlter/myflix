class UserCreation
  attr_reader :user, :invitation_token

  def initialize(user, invitation_token)
    @user = user
    @invitation_token = invitation_token
  end

  def act
    user.save
    handle_invitation
    MyMailer.delay.register_success_mail(user)
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