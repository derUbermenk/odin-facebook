class AddAttachmentsCountToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :attachments_count, :integer
  end
end
