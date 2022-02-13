require 'rails_helper'

RSpec.describe UserConnection, type: :model do
  describe 'Validations' do
    before :example do
      @u1 = create(:user)
      @u2 = create(:user, email: 'non@email.com')

      create(:user_connection, :pending, initiator: @u1, recipient: @u2)
    end

    it { should validate_presence_of(:status) }

    it 'should be invalid when there is already a connection involving the two given users' do
      new_connection = build(:user_connection, :pending, initiator: @u2, recipient: @u1)
      expect(new_connection).to_not be_valid
    end

    it 'should not be able to establish a connection with self' do
      new_connection = build(:user_connection, :pending, initiator: @u1, recipient: @u1)
      expect(new_connection).to_not be_valid
    end
  end

  describe 'Associations' do
    it { should belong_to(:initiator).class_name('User') }
    it { should belong_to(:recipient).class_name('User') }
  end
end
