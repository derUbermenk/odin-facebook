class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, foreign_key: 'author_id'
  has_many :post_likes, foreign_key: 'liker_id', inverse_of: 'liker', class_name: 'PostLike'
  has_many :liked_posts, through: :post_likes, source: :post
  has_many :comments

  # has_many :messages
  has_many :sent_friend_requests, UsersHelper::FriendRequest.requests(:recipient),
           foreign_key: 'initiator_id', class_name: 'UserConnection'
  has_many :received_friend_requests, UsersHelper::FriendRequest.requests(:initiator),
           foreign_key: 'recipient_id', class_name: 'UserConnection'

  validates :username, :email, presence: true

  # returns all users that have no connections with user
  def self.no_connections(user)
    excluded_ids = user.friends.pluck(:id) | user.sent_friend_requests.pluck(:recipient_id) | user.received_friend_requests.pluck(:initiator_id)
    User.where.not(id: excluded_ids).order('RANDOM()').limit(20)
  end

  include UsersHelper::FriendRequest
  include UsersHelper::Friends
  include UsersHelper::PostLiking
  include UsersHelper::PostSharing
end
