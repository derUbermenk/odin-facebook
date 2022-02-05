class AddAttachesCountToAttachments < ActiveRecord::Migration[6.1]
  def change
    add_column :attachments, :attaches_count, :integer
  end
end
