class UserConnection < ApplicationRecord
  enum status: [:pending, :accepted]
  belongs_to :initiator, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  # creates a connection
  def self.request_connection(initiator, recipient)
    UserConnection.create(
      initiator: initiator,
      recipient: recipient,
      status: :pending
    )
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
end
