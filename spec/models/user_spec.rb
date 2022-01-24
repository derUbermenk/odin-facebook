require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'Validations' do
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

    it 'is invalid when there is a similar email' do
      described_class.create(
        username: 'Re Peter',
        email: 'ch@gmail.com',
        password: '55treeAnts',
        reset_password_token: 'rabbit',
        reset_password_sent_at: DateTime.now,
        remember_created_at: DateTime.now
      )

      expect(subject).to_not be_valid
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
    # it { should have_many(:friends) }
    # it { should have_many(:messages) }
  end
end
