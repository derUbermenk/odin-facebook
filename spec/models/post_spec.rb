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
    end

  end

  describe 'Shares' do
    describe '#shares_count' do
      it 'returns the number of shares of a post' 

      it 'decreases when shares are deleted'

      it 'increases when the post is shared'
    end
  end
end
