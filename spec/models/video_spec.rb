require 'spec_helper'

describe Video, :type => :model do
  it { should belong_to(:category) }
  it { should have_many(:reviews).order("created_at DESC")}
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe 'search_by_title' do
    it 'returns an empty array if there is no match' do
      futurama = Video.create(title: 'Futurama', description: 'cool')
      back_to_future = Video.create(title: 'Back to Future', description: 'cool')

      expect(Video.search_by_title('hello')).to eq([])
    end

    it 'returns an array of one video for an exact match' do
      futurama_s1 = Video.create(title: 'Futurama Season 1', description: 'cool')
      back_to_future = Video.create(title: 'Back to Future', description: 'cool')

      expect(Video.search_by_title('Futurama Season 1')).to eq([futurama_s1])
    end

    it 'returns an array of one video for a partial match' do
      futurama_s1 = Video.create(title: 'Futurama Season 1', description: 'cool')
      back_to_future = Video.create(title: 'Back to Future', description: 'cool')

      expect(Video.search_by_title('Futurama')).to eq([futurama_s1])
    end
    it 'returns an array of matched videos ordered by created_at' do
      futurama_s1 = Video.create(title: 'Futurama Season 1', description: 'cool', created_at: 2.day.ago)
      futurama = Video.create(title: 'Futurama', description: 'cool', created_at: 1.day.ago)
      back_to_future = Video.create(title: 'Back to Future', description: 'cool', created_at: 3.day.ago)

      expect(Video.search_by_title('Futur')).to eq([futurama, futurama_s1, back_to_future])
    end

    it 'returns an empty array if title is empty string' do
      futurama = Video.create(title: 'Futurama', description: 'cool', created_at: 1.day.ago)
      back_to_future = Video.create(title: 'Back to Future', description: 'cool', created_at: 3.day.ago)

      expect(Video.search_by_title('')).to eq([])
    end
  end

  describe ".search", :elasticsearch do
    let(:refresh_index) do
      Video.import
      Video.__elasticsearch__.refresh_index!
    end

    context "with title" do
      it "returns no results when there's no match" do
        Fabricate(:video, title: "Futurama")
        refresh_index

        expect(Video.search("whatever").records.to_a).to eq []
      end

      it "returns an empty array when there's no search term" do
        futurama = Fabricate(:video)
        south_park = Fabricate(:video)
        refresh_index

        expect(Video.search("").records.to_a).to eq []
      end

      it "returns an array of 1 video for title case insensitve match" do
        futurama = Fabricate(:video, title: "Futurama")
        south_park = Fabricate(:video, title: "South Park")
        refresh_index

        expect(Video.search("futurama").records.to_a).to eq [futurama]
      end

      it "returns an array of many videos for title match" do
        star_trek = Fabricate(:video, title: "Star Trek")
        star_wars = Fabricate(:video, title: "Star Wars")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_trek, star_wars]
      end
    end
  end
end