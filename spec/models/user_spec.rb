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

    it 'is invalid there is a similar email' do
      subject.email = 'default@email.com' 
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

    describe 'post associations' do
      it { should have_many(:posts) }
      it { should have_many(:comments) }
      it { should have_many(:post_likes) }
      it { should have_many(:liked_posts).class_name('Post') }
    end

    describe 'connection associations' do
      describe 'one directional connection associations' do
        it { should have_many(:initiated_connections).class_name('UserConnection') }
        it { should have_many(:received_friend_requests).class_name('UserConnection') }
        it { should have_many(:sent_friend_requests).class_name('UserConnection') }
      end

      describe 'bi directional user_connection associations' do
        # associations related to user_connections defined on the user model
        #   consider the fact that the user model can either be a recipient 
        #   or an initiator in a two sided connection these associations where 
        #   designed to handle querying those without taking into account if 
        #   the user is either of the roles in a user_connection.
        #
        # due to the complexity custom scopes where written and where stored
        #   in a different module to lessen complexity. Therefore the associations
        #   mentioned here were tested in specs that refer to their specific modules
        # 
        # likewise testing just asserts that the user model is capable of calling the
        #   associations but are not in itself responsible to checking the results
        it 'expected to have many connections' do
          expect(subject).to respond_to(:connections)
        end

        it 'expected to have many accepted_connections' do
          expect(subject).to respond_to(:accepted_connections)
        end

        it 'expected to have many pending_connections' do
          expect(subject).to respond_to(:accepted_connections)
        end

        it 'expected to be an ActiveRecord CollectionProxy' do
          bi_directional_assocs = [
            subject.connections,
            subject.accepted_connections,
            subject.pending_connections
          ]

          expect(bi_directional_assocs).to all(be_a(ActiveRecord::Associations::CollectionProxy))
        end
      end
    end

    describe 'friends associations' do
      it 'expected to have many friends' do
        expect(subject).to respond_to(:friends)
      end

      it 'expected to be an ActiveRecord CollectionProxy' do
        expect(subject.friends).to all(be_a(ActiveRecord::Associations::CollectionProxy))
      end
    end
  end
end
