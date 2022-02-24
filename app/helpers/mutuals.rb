# handles logic for mutual friends
class Mutuals
  attr_reader :friends, :count

  def initialize(user1, user2)
    @user1 = user1
    @user2 = user2
    @friends = mutuals
    @count = mutuals.count
  end

  private

  # get the intersection between the accepted users of user1 and user2
  def mutuals
    User.where(id: accepted_connection_users(@user1))
        .where(id: accepted_connection_users(@user2))
  end

  def accepted_connection_users(user)
    # get the recipient and initiator ids of all connections for all connections where
    #   @user is either an initiator or a recipient
    as_recipient = UserConnection.where( recipient: user, status: :accepted ).pluck(:initiator_id)
    as_initiator = UserConnection.where( initiator: user, status: :accepted ).pluck(:recipient_id)

    as_recipient | as_initiator
  end
end