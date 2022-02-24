require 'rails_helper'

RSpec.describe Friends do
  let(:current_user) {
    create :user
  }

  subject {
    described_class.new(
      current_user
    )
  }

  before do
    # create 3 more users
    @user_list = 3.times.with_object([]) do |i, arr|
      arr << create(:user, email: "#{i}@email.com")
    end

    # make current user friends with first two users
    @user_list[..1].each.with_index do |other_user, index|
      if index.odd?
        create :user_connection, :accepted, initiator: other_user, recipient: current_user
      else
        create :user_connection, :accepted, initiator: current_user, recipient: other_user
      end
    end
  end

  it 'retrieves friends for the given user' do
    expect(subject.users).to contain_exactly(User.all[0], User.all[1])
  end

  it 'retrieves the friends count for the given user' do
    expect(subject.count).to eq(2)
  end
end