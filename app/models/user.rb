class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  has_many :comments
  has_many :post_likes, foreign_key: 'liker_id'
  has_many :liked_posts, through: :post_likes, source: :post 
  # has_many :messages
  has_many :sent_friend_requests, UsersHelper::FriendRequest.requests(:recipient),
           foreign_key: 'initiator_id', class_name: 'UserConnection'
  has_many :received_friend_requests, UsersHelper::FriendRequest.requests(:initiator),
           foreign_key: 'recipient_id', class_name: 'UserConnection'

  validates :username, :email, presence: true

  include UsersHelper::FriendRequest
  include UsersHelper::Friends
end
