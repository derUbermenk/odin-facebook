class UserConnection < ApplicationRecord
  enum status: [:pending, :accepted]
  belongs_to :initiator, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  validates :status, :initiator, :recipient, presence: true
  validate :no_connections_yet, on: :create
  validate :no_connections_with_self

  def no_connections_yet
    error_message = 'Connection between two users already exists'
    UserConnection.find_with_users(initiator, recipient).nil? || errors.add(:status, error_message)
  end

  def no_connections_with_self
    error_message = "Can't establish a connection with self"
    recipient == initiator && errors.add(:initiator, error_message)
  end

  # creates a connection
  def self.request_connection(initiator, recipient)
    UserConnection.create(
      initiator: initiator,
      recipient: recipient,
      status: :pending
    ).save
  end

  # turns a connection to an accepted_connection
  def self.accept_connection(initiator, recipient)
    connection = UserConnection.find_by(
      initiator: initiator, recipient: recipient, status: :pending
    )

    connection.status = :accepted
    connection.save
  end

  # can be used both for pending and accepted connections to 
  #   reject a friend request or unfriend a user
  def self.delete_connection(user1, user2)
    UserConnection.where(initiator: user1, recipient: user2)
                  .or(UserConnection.where(initiator: user2, recipient: user1))
                  .take
                  .delete
  end

  # looks for the connection with the given users
  def self.find_with_users(user1, user2)
    where(
      initiator: user1,
      recipient: user2
    ).or(
      where(
        initiator: user2,
        recipient: user1
      )
    ).take
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
