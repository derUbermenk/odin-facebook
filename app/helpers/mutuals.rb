# handles logic for mutual friends
class Mutuals
  attr_reader :friends, :count

  # @params friends_of_user1 [User::ActiveRecord_Associations_CollectionProxy]
  # @params friends_of_user2 [User::ActiveRecord_Associations_CollectionProxy]
  def initialize(friends_of_user1, friends_of_user2)
    @friends_of_user1 = friends_of_user1
    @friends_of_user2 = friends_of_user2
    @friends = mutuals
    @count = @friends.count
  end

  private

  # get the intersection between the accepted users of user1 and user2
  def mutuals
    @friends_of_user1 & @friends_of_user2
  end
end