require 'rails_helper'

RSpec.shared_context 'with existing user database' do
  def setup_users
    6.times do |i|
      create(:user, email: "default_#{i}@email.com")
    end
  end

  def setup_connections
    @users = User.all.to_a
    @user0 = @users[0]

    # set user0 friends 2, 3, 5
    @user0_friends = [@users[2], @users[3], @users[5]]
    @user0_friendships = []
    @user0_friends.each do |friend|
      friendship = create(:user_connection, :accepted, initiator: @user0, recipient: friend)
      @user0_friendships << [friendship.id, friendship.recipient_id, friend.username, friendship.accepted_at]
    end
    @user0_friendships.reverse!

    # set user3 friends 1, 2, 5
    @user3_friends = [@users[1], @users[2], @users[5]]
    @user3_friends.each do |friend|
      create(:user_connection, :accepted, initiator: friend, recipient: @users[3])
    end

    # the mutual friends of user0 and 3
    @user0_3_mutual = [@users[2], @users[5]]

    # create user4 and user0 connection as pending
    @received_requests = [create(:user_connection, :pending, initiator: @users[4], recipient: @user0)]

    # create user0 and user1 as pending
    @sent_requests = [create(:user_connection, :pending, initiator: @user0, recipient: @users[4])]

    # set user2 and user4 as nuissance pending
    create(:user_connection, :pending, initiator: @users[2], recipient: @users[4])

    # set user5 and user1 as nuissance accepted
    create(:user_connection, :pending, initiator: @users[5], recipient: @users[1])
  end

  before :example do
    setup_users
    setup_connections
  end
end