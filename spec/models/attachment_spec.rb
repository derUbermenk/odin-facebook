require 'rails_helper'

RSpec.describe Attachment, type: :model do
  describe 'Associations' do
    it { should belong_to(:post) }
    it { should belong_to(:attachable) }

    it { should have_db_column(:attachable_id) }
    it { should have_db_column(:attachable_type) }
    it { should have_db_column(:attaches_count) }
  end
end
