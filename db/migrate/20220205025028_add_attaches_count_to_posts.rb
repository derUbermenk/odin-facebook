class AddAttachesCountToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :attaches_count, :integer
  end
end
