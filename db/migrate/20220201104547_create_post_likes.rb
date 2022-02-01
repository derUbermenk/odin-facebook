class CreatePostLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :post_likes do |t|
      t.references :liker, index: true, foreign_key: { to_table: :users }
      t.references :post

      t.timestamps
    end
  end
end
