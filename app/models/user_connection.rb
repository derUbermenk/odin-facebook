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
    )
  end

  enum status: [:pending, :accepted]
  belongs_to :initiator, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  validates :status, :initiator, :recipient, presence: true
  validate :connections

  def connections
    validator = UserConnectionCustomValidator.new self
    validator.validate
  end

  # rename date columns

  def self.timestamp_attributes_for_create
    super << 'sent_at'
  end

  def self.timestamp_attributes_for_update
    super << 'accepted_at'
  end

  private_class_method :timestamp_attributes_for_create, :timestamp_attributes_for_update
end

# handles custom validations for UserConnection model
class UserConnectionCustomValidator
  def initialize(connection)
    @connection = connection
  end

  def validate
    not_connecting_with_self
    not_duplicating_connection_with_user
  end

  private

  def not_duplicating_connection_with_user
    error_message = 'Connection between two users already exists'
    UserConnection.search(@connection.initiator, @connection.recipient).none? ||
      @connection.errors.add(:status, error_message)
  end

  def not_connecting_with_self 
    error_message = "Can't establish a connection with self"
    @connection.recipient == @connection.initiator &&
      @connection.errors.add(:initiator, error_message)
  end
end
