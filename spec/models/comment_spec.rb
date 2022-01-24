require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    user = User.create(
      username: 'Re Peter',
      email: 'ch@gmail.com',
      password: '55treeAnts',
      reset_password_token: 'rabbit',
      reset_password_sent_at: DateTime.now,
      remember_created_at: DateTime.now
    )

    user.posts.create(content: 'rabbits are best animal')
  end

  describe 'Validations' do
    subject {
      User.all[0].comments.create(
        post_id: Post.all[0].id,
        content: 'rabbits are indeed good')
    }

    it 'should be valid with the correct attributes' do
     expect(subject).to be_valid
    end

    it 'should not be valid when it has no content' do
     subject.content = nil
     expect(subject).to_not be_valid
    end
  end
end
