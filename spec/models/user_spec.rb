require 'rails_helper'
require 'support/shared/User/user_and_connections'
require 'support/shared/User/user_and_likes'

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
    it { should have_many(:post_likes) }
    it { should have_many(:liked_posts).class_name('Post') }
    # it { should have_many(:sent_messages) }
    # it { should have_many(:received_messages) }

    it { should have_many(:sent_friend_requests) }
    it { should have_many(:received_friend_requests) }
    # it { should have_many(:initiated_friendships) }
    # it { should have_many(:accepted_friendships) }

    # accepted_friends, for the recipient side of an accepted connection
    # return users
    # it { should have_many(:accepted_friends) }

    # added_friends, for the initiator side of an accepted connection
    # it { should have_many(:added_friends) }

    describe 'sent_friend_requests' do
      include_context 'with existing user database'
      it 'returns all connections where user is initiator with pending status' do
        sent_friend_requests = @user0.sent_friend_requests
        expect(sent_friend_requests).to eq(@sent_requests)
      end
    end

    describe 'received_friend_requests' do
      include_context 'with existing user database'
      it 'returns all connections where user is recipient with pending status' do
        received_friend_requests = @user0.received_friend_requests
        expect(received_friend_requests).to eq(@received_requests)
      end
    end

  end

  describe 'Friends Methods' do
    include_context 'with existing user database'

    describe '#friendships' do
      it 'the friendships of user in descending order' do
        expect(@user0.friendships).to eq(@user0_friendships)
        expect(@user0.friendships.first[1]).to eq(@users[5].id)
        expect(@user0.friendships.last[1]).to eq(@users[2].id)
      end
    end

    describe '#friends' do
      it 'returns all the friends of user' do
        queried_friends = @user0.friends.to_a
        actual_friends = @user0_friends

        expect(queried_friends).to eq(actual_friends)
      end
    end

    describe '#mutual_friends' do
      it 'returns all mutual friends of the user and the given user' do
        user3 = @users[3]
        queried_mutual_friends = user3.mutual_friends(@user0).to_a
        actual_mutual_friends = @user0_3_mutual

        expect(queried_mutual_friends).to eq(actual_mutual_friends)
      end
    end

    describe '#unfriend' do
      it 'removes the targeted user from friends' do
        @user0.unfriend(@users[3])
        actual_remaining_friends = [@users[2], @users[5]]
        remaining_friends = @user0.friends.to_a

        expect(remaining_friends).to eq(actual_remaining_friends)
      end
    end

    describe '#send_request' do
      it 'sends a friends request to the specified recipient' do
        @user0.send_request(@users[1])

        expect(@user0.sent_friend_requests.to_a.size).to eq 2
        expect(@user0.sent_friend_requests.first.recipient).to eq @users[1]
      end
    end

    describe '#accept_request' do
      it 'make user as friends with initiator' do
        @user0.accept_request(@users[4])
        expect(@user0.friends.to_a).to include(@users[4])
      end
    end

    describe '#reject_request' do
      it 'rejects the request from the given user' do
        @user0.reject_request(@users[4])
        expect(@user0.received_friend_requests.to_a).to eq []
      end
    end
  end

  describe 'Post Liking Methods' do
    include_context 'with existing user, post and postlikes table'

    describe '#like' do
      it 'likes a post' do
        @user.like(@post)
        expect{ @user.like(@post) }.to change{ @post.likes_count }.by(1)
      end

      it 'adds post to liked post' do
        @user.like(@post)
        expect(@user.liked_posts).to include(@post) # @liked_post has been unliked in previous step
      end
    end

    describe '#unlike' do
      it 'unlikes a post' do
        @user.unlike(@liked_post)
        @liked_post.reload # reload post from database due to change
        expect(@liked_post.likes_count).to eq(0)
      end

      it 'removes post from liked post' do
        @user.unlike(@liked_post)
        @liked_post.reload 
        expect(@user.liked_posts).to_not include(@liked_post) # @liked_post has been unliked in previous step
      end
    end
  end

  describe 'Post Sharing' do
    describe '#share' do
      before do
        @user = create :user
        @post = create :post, author: @user 
      end

      it 'shares a post' do
        expect { @user.share(@post) }.to change { @post.shares_count }.by(1)
      end

      it 'creates a post with an attached post' do
        @new_post = @user.share(@post)
        expect(@new_post.attachments.first.attachable).to eq(@post)
      end
    end
  end
end
