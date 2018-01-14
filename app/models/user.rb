class User < ActiveRecord::Base
  include Tokenable

  has_many :reviews, -> { order("created_at DESC")}
  has_many :queue_items, -> { order("position") }

  has_many :following_relationships, class_name: "Relationship", foreign_key: "follower_id"
  has_many :leaders, through: :following_relationships
  has_many :followed_relationships, class_name: "Relationship", foreign_key: "leader_id"
  has_many :followers, through: :followed_relationships

  validates_presence_of :email, :full_name
  validates_uniqueness_of :email
  validates :password, presence: true, length: {minimum: 8}

  has_secure_password

  def to_param
    token
  end

  def queued_item?(video)
    !!QueueItem.find_by(user: self, video: video)
  end

  def can_follow?(another_user)
    self != another_user && !following_relationships.map(&:leader).include?(another_user)
  end

  def follow(user)
    following_relationships.create(leader: user)
  end

  def admin?
    !!admin
  end

  def deactivate!
    update_column("active", false)
  end
end
