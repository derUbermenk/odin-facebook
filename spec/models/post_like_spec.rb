require 'rails_helper'

RSpec.describe PostLike, type: :model do
  describe 'Associations' do
    it { should have_db_column(:liker_id).of_type(:integer) }
    it { should have_db_column(:post_id).of_type(:integer) }

    it { should belong_to(:liker) }
    it { should belong_to(:post) }
  end
end
