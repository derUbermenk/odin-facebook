require 'rails_helper'

RSpec.describe Post, type: :model do

  describe 'Associations' do

    it { should have_many(:comments) }
    it { should have_many(:likes).class_name('PostLike') }
    it { should have_db_column(:likes_count).of_type(:integer) }

    # for sharing
    it { should have_many(:attachments) }
    it { should have_db_column(:attaches_count).of_type(:integer) }
    it { should have_db_column(:attachments_count).of_type(:integer) }
  end

  describe 'Validations' do
    before do
      User.create(
        username: 'Re Peter',
        email: 'ch@gmail.com',
        password: '55treeAnts',
        reset_password_token: 'rabbit',
        reset_password_sent_at: DateTime.now,
        remember_created_at: DateTime.now
      )

      @shareable_post = User.first.posts.create(content: 'share this')
    end

    subject {
      User.first.posts.create(content: 'something')
    }


    it 'is valid with the correct attributes' do
      expect(subject).to be_valid
    end
    
    it 'is invalid when the content is more than 500 letters' do
      subject.content = Array.new(550, 'words').join(' ')
      expect(subject).to_not be_valid
    end
    
    context 'for content and attachments' do
      it 'is invalid when there is no content and attachments' do
        subject.content = nil
        subject.attachments = Attachment.none

        expect(subject).to_not be_valid
      end

      it 'is valid when there is content even with no attachment' do
        subject.content = 'something'
        expect(subject).to be_valid
      end

      it 'is valid when there are attachments even with no content' do
        subject.content = nil
        subject.attachments.create(attachable: @shareable_post)

        expect(subject).to be_valid
      end

      it 'is valid when there are both attachments and content' do
        subject.content = 'something'
        subject.attachments.create(attachable: @shareable_post)

        expect(subject).to be_valid
      end

      it 'is valid when there is more than one attachment but all are not of type Post' do
        # check this once posting photos allowed
      end

      it 'is invalid when there is an attachment of type Post and there are more than 1 attachments' do
        another_shareable_post = User.first.posts.create(content: 'share this too')
        subject.attachments.create(attachable: @shareable_post)
        subject.attachments.create(attachable: another_shareable_post)

        expect(subject).to_not be_valid
      end

      it 'is valid when there is only one attachment and it is of type post' do
        subject.attachments.create(attachable: @shareable_post)
        expect(subject).to be_valid
      end
    end

  end

  describe 'Shares' do
    describe '#shares_count' do
      before do
        @user = create :user

        @user2 = create :user, email: 'user2@email.com'
        @post = create :post, author: @user2

        2.times { @user.share(@post) } # create two shares of post
      end

      it 'returns the number of shares of a post' do
        expect(@post.shares_count).to eq(2)
      end

      it 'decreases when shares are deleted' do
        expect {
          @user.posts.last.destroy
          @post.reload
        }.to change { @post.shares_count }.by(-1)
      end

      it 'increases when the post is shared' do
        expect {
          @user.share(@post)
          @post.reload
        }.to change { @post.shares_count }.by(1)
      end
    end
  end

  describe 'Feed' do
    before do
      # create 3 users
      3.times do |i|
        create :user, email: "#{i}@email.com"
      end

      # make user 0 and 1 to be friends
      @user = User.first
      @user_friend = User.all[1]

      UserConnection.create(
        initiator: @user_friend,
        recipient: @user,
        status: :accepted
      ) 

      # make each user post something 
      User.all.each do |user|
        user.posts.create(
          content: user.email
        )
      end
      # expected_user_feed = user0.posts + user1.posts
      @expected_user_feed = Post.where(author_id: [@user.id, @user_friend.id]).order('created_at DESC')
    end

    it 'returns all posts that are from user and friends' do
      posts = Post.feed(@user).pluck(:id)
      expect(posts).to eq(@expected_user_feed.pluck(:id))
    end
  end
end


      end
    end

  end

  describe 'Shares' do
    describe '#shares_count' do
      before do
        @user = create :user

        @user2 = create :user, email: 'user2@email.com'
        @post = create :post, author: @user2

        2.times { @user.share(@post) } # create two shares of post
      end

      it 'returns the number of shares of a post' do
        expect(@post.shares_count).to eq(2)
      end

      it 'decreases when shares are deleted' do
        expect {
          @user.posts.last.destroy
          @post.reload
        }.to change { @post.shares_count }.by(-1)
      end

      it 'increases when the post is shared' do
        expect {
          @user.share(@post)
          @post.reload
        }.to change { @post.shares_count }.by(1)
      end
    end
  end

  describe 'Feed' do
    before do
      # create 3 users
      3.times do |i|
        create :user, email: "#{i}@email.com"
      end

      # make user 0 and 1 to be friends
      @user = User.first
      @user_friend = User.all[1]

      UserConnection.create(
        initiator: @user_friend,
        recipient: @user,
        status: :accepted
      ) 

      # make each user post something 
      User.all.each do |user|
        user.posts.create(
          content: user.email
        )
      end
      # expected_user_feed = user0.posts + user1.posts
      @expected_user_feed = Post.where(author_id: [@user.id, @user_friend.id]).order('created_at DESC')
    end

    it 'returns all posts that are from user and friends' do
      posts = Post.feed(@user).pluck(:id)
      expect(posts).to eq(@expected_user_feed.pluck(:id))
    end
  end
end
