require 'rails_helper'

FactoryBot.define do
  factory :user do
    username { 'default' }
    email { 'default@email.com' }
    password { 'default' }
  end
end

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
end
