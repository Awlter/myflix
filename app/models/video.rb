class Video < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name ['myflix', Rails.env].join('_')

  belongs_to :category
  has_many :reviews, -> { order('created_at DESC') }
  has_many :queue_items

  validates :title, :description, presence: true

  mount_uploader :small_cover, SmallCoverUploader
  mount_uploader :large_cover, LargeCoverUploader

  def self.search_by_title(title)
    return [] if title.blank?
    where('title LIKE ?', "%#{title}%").order('created_at DESC')
  end

  def as_indexed_json(option={})
    as_json(only: [:title])
  end
end