require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order("position") }

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
end
