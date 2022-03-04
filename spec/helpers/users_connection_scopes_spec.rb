require 'rails_helper'

# test connection scopes for user
RSpec.describe UsersConnectionScopes do

  let(:current_user) { create :user }

  before do
    # create 4 other users
    4.times do |i|
      create :user, email: "#{i}@email.com"
    end

    # make first 2 users have accepted connections
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

  describe '#connections' do
    it 'returns all the UserConnections of user' do
      user_conn = UserConnection.all
      expect(current_user.connections).to contain_exactly(user_conn[0], user_conn[1], user_conn[2])
    end
  end

  describe '#accepted_connections' do
    it 'returns all the UserConnections with accepted status' do
      user_conn = UserConnection.all
      expect(current_user.accepted_connections).to contain_exactly(user_conn[0], user_conn[1])
    end
  end

  describe '#pending_connections' do
    it 'returns all the UserConnections with pending status' do
      user_conn = UserConnection.all
      expect(current_user.pending_connections).to contain_exactly(user_conn[2])
    end
  end
end