# handles logic for friends
class Friends
  attr_reader :users, :count

  def initialize(user)
    @user = user
    @users = friends
    @count = @users.count
  end

  private

  # find all users which have an accepted connection with
  #   @user
  def friends
    # get the ids for all connections that have been accepted
    User.where(
      id: accepted_connection_users
    )
  end

  def accepted_connection_users
    # get the recipient and initiator ids of all connections for all connections where
    #   @user is either an initiator or a recipient
    as_recipient = UserConnection.where(recipient: @user, status: :accepted).pluck(:initiator_id)
    as_initiator = UserConnection.where(initiator: @user, status: :accepted).pluck(:recipient_id)

    as_recipient | as_initiator
  end
end

