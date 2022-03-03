# Table name: users
#   string "username", default: "", null: false
#   string "email", default: "", null: false
#   string "encrypted_password", default: "", null: false
#   string "reset_password_token"
#   datetime "reset_password_sent_at"
#   datetime "remember_created_at"
#   datetime "created_at", precision: 6, null: false
#   datetime "updated_at", precision: 6, null: false
#   index ["email"], name: "index_users_on_email", unique: true
#   index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # posts related asssociations
  has_many :posts, foreign_key: 'author_id'
  has_many :post_likes, foreign_key: 'liker_id', 
           inverse_of: 'liker', class_name: 'PostLike'
  has_many :liked_posts, through: :post_likes, source: :post
  has_many :comments

  # one directional user_connections associations
  has_many :initiated_connections, foreign_key: 'initiator_id', class_name: 'UserConnection'
  has_many :received_connections, foreign_key: 'recipient_id', class_name: 'UserConnection'
  has_many :received_friend_requests, -> { where status: :pending }, 
           class_name: 'UserConnection', foreign_key: 'recipient_id'
  has_many :sent_friend_requests, -> { where status: :pending},
           class_name: 'UserConnection', foreign_key: 'initiator_id'

  # bi directional user_connections associations
  has_many :connections, UsersConnectionScopes.connections, 
           class_name: 'UserConnection'
  has_many :accepted_connections, UsersConnectionScopes.accepted_connections,
           class_name: 'UserConnection'
  has_many :pending_connections, UsersConnectionScopes.pending_connections,
           class_name: 'UserConnection'

  has_many :friends, UsersFriendScopes.friends, class_name: 'User'

  scope :and_friends, ->(user) { where(id: user.id).or(where(id: user.friends)) }

  # validations
  validates :username, :email, presence: true

  # returns User relations of mutual friends
  def mutual(other_user)
    @mutual ||= Mutuals.new(self.friends, other_user.friends)
  end

  def liked?(post)
    liked_posts.include?(post)
  end
end
