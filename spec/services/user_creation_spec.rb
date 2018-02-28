require 'spec_helper'

describe UserCreation do
  context "with valid user info and valid card" do
    let(:customer) { double("customer", successful?: true, token: 'abcdefg') }

    before do
      allow(StripeWrapper::Customer).to receive('create').and_return(customer)
    end

    after do
      ActionMailer::Base.deliveries.clear
    end

    it "creates a new user" do
      UserCreation.new(User.new(Fabricate.attributes_for(:user)), nil).create('123123')
      expect(User.count).to eq 1
    end

    it "sets the customer id" do
      UserCreation.new(User.new(Fabricate.attributes_for(:user)), nil).create('123123')
      expect(User.first.customer_id).to eq('abcdefg')
    end

    it "makes the inviter and the recipient follow each other" do
      inviter = Fabricate(:user)
      invitation = Fabricate(:invitation, inviter: inviter)
      UserCreation.new(User.new(Fabricate.attributes_for(:user)), invitation.token).create('123123')
      expect(User.last.leaders).to eq [inviter]
      expect(User.last.followers).to eq [inviter]
    end

    it "expire the invitation token upon acceptance" do
      inviter = Fabricate(:user)
      invitation = Fabricate(:invitation, inviter: inviter)
      UserCreation.new(User.new(Fabricate.attributes_for(:user)), invitation.token).create('123123')
      expect(invitation.reload.token).to be_nil
    end
  end

  context "valid personal info and declined card" do
    before do
      customer = double("customer", successful?: false, error_message: 'declined card')
      allow(StripeWrapper::Customer).to receive('create').and_return(customer)
    end

    it 'does not create a new user' do
      UserCreation.new(User.new(Fabricate.attributes_for(:user)), nil).create('123123')
      expect(User.count).to eq 0
    end
  end

  context "with invalid personal info" do
    before do
      UserCreation.new(User.new(email: Faker::Internet.email), nil).create('123123')
    end

    it 'does not create a new user' do
      expect(User.count).to eq 0
    end

    it 'does not charge card' do
      expect(StripeWrapper::Customer).not_to receive(:create)
    end
  end

  context "sending email" do
    context "with valid input" do
      after do
        ActionMailer::Base.deliveries.clear
      end

      it "sends email" do
        customer = double("customer", successful?: true, token: 'abcdefg')
        allow(StripeWrapper::Customer).to receive('create').and_return(customer)

        user_attributes = Fabricate.attributes_for(:user)
        UserCreation.new(User.new(user_attributes), nil).create('123123')
        expect(ActionMailer::Base.deliveries.last.to).to eq [user_attributes[:email]]
        expect(ActionMailer::Base.deliveries.last.body).to include user_attributes[:full_name]
      end
    end

    context "with invalid input" do
      after do
        ActionMailer::Base.deliveries.clear
      end

      it "does not send email" do
        UserCreation.new(User.new(Fabricate.attributes_for(:user, full_name: nil)), nil).create('123123')
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end