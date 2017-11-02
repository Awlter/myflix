require 'spec_helper'

Rspec.describe RelationshipsController do
  describe "GET index" do
    context "as an authorized user" do
      it "sets @relationships to the current user's following relationship" do
        user = Fabricate(:user)
        set_current_user(user)
        other_user = Fabricate(:user)
        relationship = Fabricate(:relationship, follower: user, leader: other_user)
        get :index
        expect(assigns(:leaders)).to eq [other_user]
      end
    end

    context "as a guest" do
      it_behaves_like "requires sign in" do
        let(:action) { get :index}
      end
    end
  end

  describe "DELETE destroy" do
    let(:user) { Fabricate(:user) }
    let(:other_user) { Fabricate(:user) }
    let(:relationship) { Fabricate(:relationship, follower: user, leader: other_user) }

    context "as an authorized user" do
      before do
        set_current_user(user)
      end

      it "deletes the relationship" do
        expect(Relationship.all).to eq [relationship]
        post :destroy, id: relationship.id
        expect(Relationship.all).to be_empty
      end

      it "redirects to people path" do
        post :destroy, id: relationship.id
        expect(response).to redirect_to people_path
      end

      it "does not delete when current user is not follower" do
        other_relationship = Fabricate(:relationship, follower: Fabricate(:user), leader: other_user)
        post :destroy, id: other_relationship.id
        expect(Relationship.all).to eq [other_relationship]
      end
    end

    context "as a guest" do
      it_behaves_like "requires sign in" do
        let(:action) { post :destroy, id: relationship.id }
      end
    end
  end
end
