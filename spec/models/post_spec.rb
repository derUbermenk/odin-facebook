require 'rails_helper'

RSpec.describe Post, type: :model do

  describe 'Associations' do

    it { should have_many(:comments) }
    it { should have_many(:likes).class_name('PostLike') }
    it { should have_db_column(:likes_count).of_type(:integer) }

    # for sharing
    it { should have_many(:shares).class_name('Post') }
    it { should have_db_column(:attachment_count).of_type(:integer) }
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
    end

    subject {
      User.all[0].posts.create(
        content: 'good rabbits'
      )
    }

    it 'is valid with the correct attributes' do
      expect(subject).to be_valid
    end

    it 'is invalid when there is no content' do
      subject.content = nil
      expect(subject).to_not be_valid
    end

    it 'is invalid when the content is more than 500 letters' do
      subject.content = Array.new(550, 'words').join(' ')
      expect(subject).to_not be_valid
    end
  end
end
