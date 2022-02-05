class AddDefaultToPostLikesCount < ActiveRecord::Migration[6.1]
  def change
    change_column :posts, :likes_count, :integer, default: 0
  end
end
