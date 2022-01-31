require 'rails_helper'

RSpec.describe UserConnection, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:status) }
  end

  describe 'Associations' do
    it { should belong_to(:initiator).class_name('User') }
    it { should belong_to(:recipient).class_name('User') }
  end
end
