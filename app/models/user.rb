class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :posts
  has_many :comments

  # has_many :messages
  has_many :sent_friend_requests, -> { where status: :pending },
           foreign_key: 'initiator_id', class_name: 'UserConnection'
  has_many :received_friend_requests, -> { where status: :pending },
           foreign_key: 'recipient_id', class_name: 'UserConnection'
  # rejecting pending UserConnections deletes the record

=begin
  # returns UserConnection record
  has_many :initiated_friendships, -> { where status: :accepted },
           foreign_key: 'initiator_id', class_name: 'UserConnection'
  has_many :accepted_friendships, -> { where status: :accepted },
           foreign_key: 'recipient_id', class_name: 'UserConnection'

  # returns User record
  # has_many :initiators, through: :initiated_friendships, class_name: 'User'
  has_many :added_friends, through: :initiated_friendships,
            source: :recipient

  # has_many :recipients, through: :accepted_friendships, class_name: 'User'
  has_many :accepted_friends, through: :accepted_friendships,
            source: :initiator
=end

  # Validations
  validates :username, :email, presence: true

  def friends
    accepted_friends.or added_friends
  end

  def mutual_friends(other_user)
    friends.and other_user.friends
  end

  def unfriend(user)
    UserConnection.delete_connection(user, self)
  end

  private

  def accepted_friends
    # get all friends of self for which user is the recipient in the friendship
    ids = UserConnection.where(recipient: self.id, status: :accepted).pluck(:initiator_id)
    User.where(id: ids)
  end

  def added_friends
    # get all friends of self for which user is the initiator in the friendship
    ids = UserConnection.where(initiator: self.id, status: :accepted).pluck(:recipient_id)
    User.where(id: ids)
  end
end
