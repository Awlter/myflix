require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order("position") }
  it { should have_many(:reviews).order("created_at DESC")}
  it { should ensure_length_of(:password).is_at_least(8) }

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:user) }
  end

  describe "#queued_item?" do
    it 'returns true when the video is queued' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queued_item = Fabricate(:queue_item, video: video, user: user)
      expect(user.queued_item?(video)).to be_truthy
    end

    it 'returns false when the video is not queued' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      expect(user.queued_item?(video)).to be_falsey
    end
  end

  describe "#follow" do
    it "makes one user follow another user" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      user1.follow(user2)
      expect(user1.leaders.first).to eq user2
    end
  end

  describe "#deactive!" do
    it "update the active column to false" do
      user = Fabricate(:user, active: true)
      user.deactivate!
      expect(user.active).to be_false
    end
  end
end
