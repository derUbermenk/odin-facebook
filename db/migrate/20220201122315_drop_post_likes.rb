class DropPostLikes < ActiveRecord::Migration[6.1]
  def change
    drop_table :post_likes
  end
end
