require 'rails_helper'
require 'support/shared/user_and_connections'

RSpec.describe User, type: :model do
  
  describe 'Validations' do

    before(:example) do
      create :user
    end

    subject {
      described_class.new(
        username: 'Ch Asuncion',
        email: 'ch@gmail.com',
        password: 'k77rewet'
      )
    }

    it 'is valid with the correct attributes' do
      expect(subject).to be_valid
    end

    it 'is invalid when there is no username' do
      subject.username = nil
      expect(subject).to_not be_valid
    end

    it 'is invalid when there is no email' do
      subject.username = nil
      expect(subject).to_not be_valid
    end

    context 'when there is a similar email' do
      it 'is invalid' do
        subject.email = 'default@email.com' 
        expect(subject).to_not be_valid
      end
    end

    it 'is invalid when there is no password' do
      subject.password = nil
      expect(subject).to_not be_valid
    end

    it 'is invalid when the password is not > 6 characters' do
      subject.password = '4lett'
      expect(subject).to_not be_valid
    end
  end

  describe 'Asssociations' do
    it { should have_many(:posts) }
    it { should have_many(:comments) }
    # it { should have_many(:sent_messages) }
    # it { should have_many(:received_messages) }

    it { should have_many(:sent_friend_requests) }
    it { should have_many(:received_friend_requests) }
    it { should have_many(:initiated_friendships) }
    it { should have_many(:accepted_friendships) }
  end

  describe 'Instance Methods' do
    include_context 'user_and_connections'

    before :example do
      # see setup_connections for user_connections
      setup_users # make 6 users
      setup_connections # connect those users

      @user0 = @users[0]
    end

    describe '#friends' do
      it 'returns all the friends of user' do
        friends = @user0.friends.to_a
        actual_friends = [@users[2], @users[3]]

        expect(friends).to eq(actual_friends)
      end
    end

    describe '#mutual_friends' do
      it 'returns all mutual friends of the user and the given user' do
        user3 = @users[3]
        mutual_friends = user3.mutual_friends(@user0)
        actual_mutual_friends = [@users[1], @users[5]]

        expect(mutual_friends).to eq(actual_mutual_friends)
      end
    end

    describe '#unfriend' do
      it 'removes the targeted user from friends' do
        @user0.unfriend(@users[0])
        actual_remaining_friends = [@users[3]]
        remaining_friends = @user0.friends.to_a

        expect(remaining_friends).to eq(actual_remaining_friends)
      end
    end

    describe '#accept' do
      it 'makes the two users as friends'
    end
  end
end
