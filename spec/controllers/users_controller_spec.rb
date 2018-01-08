require 'spec_helper'

describe UsersController, :type => :controller do
  describe "GET new" do
    it "returns an instance of User" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "GET new_with_token" do
    it "returns an instance of User with email presented" do
      invitation = Fabricate(:invitation)
      get :new_with_token, token: invitation[:token]
      expect(assigns(:user).email).to eq invitation.recipient_email
    end

    it "redirects expired token page for invalid token" do
      get :new_with_token, token: 'random'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "GET show" do
    let(:user) { Fabricate(:user) }

    context "as an authorized user" do
      before do
        session[:user_id] = user.id
      end

      it "responses successfully" do
        get :show, id: user.id
        expect(response).to be_success
      end
    end

    context "as a guest" do
      it_behaves_like 'requires sign in' do
        let(:action) { get :show, id: user.id }
      end
    end
  end

  describe "POST create" do
    context "successful user registration" do
      it "redirects to sign in path" do
        result = double('result', successful?: true)
        allow_any_instance_of(UserCreation).to receive('create').and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sign_in_path
      end
    end

    context "failed user registration" do
      let(:result) { double('result', successful?: false, error_message: 'some error message') }

      before do
        allow_any_instance_of(UserCreation).to receive('create').and_return(result)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123123'
      end

      it 'renders :new template' do
        expect(response).to render_template :new
      end
      it 'set the flash error message' do
        expect(flash[:error]).to be_present
      end
      it 'sets new @user' do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end
end