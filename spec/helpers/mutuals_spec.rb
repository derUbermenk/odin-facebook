require "rails_helper"

RSpec.describe Mutuals do
  let(:current_user) { create :user }

  let(:opposite_user) { create :user, email: 'other_user@email.com' }

  subject { 
    described_class.new(current_user, opposite_user) 
  }

  before do
    # create 3 more users
    user_list = 3.times.with_object([]) do |i, arr|
      arr << create(:user, email: "#{i}@email.com")
    end

    # make current user friends with first two users
    user_list[..1].each.with_index do |other_user, index|
      if index.odd?
        create :user_connection, :accepted, initiator: other_user, recipient: current_user
      else
        create :user_connection, :accepted, initiator: current_user, recipient: other_user
      end
    end

    # make other_user be friends with all users except it and user_list[0]
    User.where.not(id: [user_list.first, opposite_user.id]).each.with_index do |other_user, index|
      if index.odd?
        create :user_connection, :accepted, initiator: other_user, recipient: opposite_user
      else
        create :user_connection, :accepted, initiator: opposite_user, recipient: other_user
      end
    end
  end

  it 'retrieves mutuals for the given users' do
    expect(subject.friends).to contain_exactly(User.all[1])
  end

  it 'retrieves the mutual friends count for the given user' do
    expect(subject.count).to eq(1)
  end
end