require 'rails_helper'

RSpec.describe FriendRequest, type: :model do
  before do
    User.create(
      username: 'Re Peter I',
      email: 'ch@gmail.com',
      password: '55treeAnts',
      reset_password_token: 'rabbit',
      reset_password_sent_at: DateTime.now,
      remember_created_at: DateTime.now
    )

    User.create(
      username: 'Re Peter II',
      email: 'ch@gmail.com',
      password: '55treeAnts',
      reset_password_token: 'rabbit',
      reset_password_sent_at: DateTime.now,
      remember_created_at: DateTime.now
    )
  end

  describe 'Validations' do
    subject {
      User.all[0].friend_requests_sent.build(
        User.all[1]
      )
    }

    it 'should be valid with the correct attributes' do
      expect(subject).to be_valid
    end

    it 'should not be valid when it has no receipient' do
      subject.recipient = nil
      expect(subject).to_not be_valid
    end

    it 'should be valid when there is no sender' do
      subject.sender = nil
      expect(subject).to_not be_valid
    end
  end
end
