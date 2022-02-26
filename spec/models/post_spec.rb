require 'rails_helper'

RSpec.describe Post, type: :model do

  describe 'Associations' do

    it { should have_many(:comments) }
    it { should have_many(:likes).class_name('PostLike') }
    it { should have_db_column(:likes_count).of_type(:integer) }

    # for sharing
    it { should have_many(:attachments) }
    it { should have_db_column(:attaches_count).of_type(:integer) } # aliased as shares_count
    it { should have_db_column(:attachments_count).of_type(:integer) }
  end
end