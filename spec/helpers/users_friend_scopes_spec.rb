require 'rails_helper'

# test connection scopes for user
RSpec.describe UsersFriendScopes do

  # current_user does create :user only when called
  let(:current_user) { create :user }

  before do
    # create 4 other users
    4.times do |i|
      create :user, email: "#{i}@email.com"
    end

    # make first 2 users have accepted connections
    # current_user is only created here, therefore
    #   it is last entry in User.all
    User.all[..1].each.with_index do |user, index|
      initiator = index.odd? ? user : current_user
      recipient = index.odd? ? current_user : user
      create(
        :user_connection, 
        :accepted,
        initiator: initiator,
        recipient: recipient
      )
    end

    # make 3rd user have pending connection
    create :user_connection, :pending, initiator: User.all[2], recipient: current_user

    # let 4th user have no connection
  end
  
  describe '#friends' do 
    it 'returns all users for which current_user is friends' do
      users = User.all
      expect(current_user.friends).to contain_exactly(users[0], users[1])
    end
  end
end