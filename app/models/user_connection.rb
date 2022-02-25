# Table name: user_connections
#
#   t.bigint "author_id", null: false
#    t.text "content"
#    t.datetime "created_at", precision: 6, null: false
#    t.datetime "updated_at", precision: 6, null: false
#    t.integer "likes_count", default: 0
#    t.integer "attachments_count", default: 0
#    t.integer "attaches_count", default: 0
#    t.index ["author_id"], name: "index_posts_on_author_id"
#
class UserConnection < ApplicationRecord

  # search for the connection which involves the given users
  # @param users [Array]
  # @return UserConnection
  def self.search(user1, user2)
    UserConnection.where(
      initiator: user1,
      recipient: user2
    ).or(
      where(
        initiator: user2,
        recipient: user1
      )
    ).take || nil 
  end

  enum status: [:pending, :accepted]
  belongs_to :initiator, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  validates :status, :initiator, :recipient, presence: true
  validate :no_connections_yet, on: :create
  validate :no_connections_with_self

  def no_connections_yet
    error_message = 'Connection between two users already exists'
    UserConnection.search(initiator, recipient).nil? || errors.add(:status, error_message)
  end

  def no_connections_with_self
    error_message = "Can't establish a connection with self"
    recipient == initiator && errors.add(:initiator, error_message)
  end

  private_class_method

  # rename date columns

  def self.timestamp_attributes_for_create
    super << 'sent_at'
  end

  def self.timestamp_attributes_for_update
    super << 'accepted_at'
  end
end