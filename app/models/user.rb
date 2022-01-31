class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :posts
  has_many :comments

  # has_many :messages
  has_many :sent_friend_requests,
           -> { where(status: :pending).includes(:recipient).order(sent_at: :desc) },
           foreign_key: 'initiator_id', class_name: 'UserConnection'
  has_many :received_friend_requests,
           -> { where(status: :pending).includes(:initiator).order(sent_at: :desc) },
           foreign_key: 'recipient_id', class_name: 'UserConnection'

  validates :username, :email, presence: true

  def friendships
    accepted_friendships | added_friendships
  end

  def friends
    accepted_friends.or added_friends
  end

  def mutual_friends(other_user)
    friends.and other_user.friends
  end

  def unfriend(user)
    UserConnection.delete_connection(user, self)
  end

  # sends a friend request
  def send_request(recipient)
    sent_friend_requests.create(
      recipient: recipient
    )
  end

  # accepts a friend request
  def accept_request(sender)
    UserConnection.accept_connection(sender, self)
  end

  def reject_request(sender)
    UserConnection.delete_connection(self, sender)
  end

  private

  # accepted refers to all connections where self is recipient
  # added refers to all connections where self is initiator

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

  def accepted_friendships
    UserConnection.joins(:initiator).where(
      recipient_id: id, status: :accepted
    ).pluck('user_connections.id', :initiator_id, 'users.username', :accepted_at)
  end

  def added_friendships
    UserConnection.joins(:recipient).where(
      initiator_id: id, status: :accepted
    ).pluck('user_connections.id', :recipient_id, 'users.username', :accepted_at)
  end
end
