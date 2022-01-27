class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :posts
  has_many :comments

  "has_many :messages"

  has_many :sent_friend_requests, -> { where status: :pending },
           foreign_key: 'initiator_id', class_name: 'UserConnection'
  has_many :received_friend_requests, -> { where status: :pending },
           foreign_key: 'recipient_id', class_name: 'UserConnection'

  # rejecting pending UserConnections deletes the record
  has_many :initiated_friendships, -> { where status: :accepted },
           foreign_key: 'initiator_id', class_name: 'UserConnection'
  has_many :accepted_friendships, -> { where status: :accepted },
           foreign_key: 'recipient_id', class_name: 'UserConnection'

  # Validations
  validates :username, :email, presence: true
end
