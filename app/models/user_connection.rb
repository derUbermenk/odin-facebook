class UserConnection < ApplicationRecord
  enum status: [:pending, :accepted]
  belongs_to :initiator, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  # can be used both for pending and accepted connections to 
  #   reject a friend request or unfriend a user
  def self.delete_connection(user1, user2)
    UserConnection.where(initiator: user1, recipient: user2)
                  .or(UserConnection.where(initiator: user2, recipient: user1))
                  .take
                  .delete
  end
end
