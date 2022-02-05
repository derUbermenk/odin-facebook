class RemoveAttachesCountFromAttachments < ActiveRecord::Migration[6.1]
  def change
    remove_column :attachments, :attaches_count
  end
end
