class CreatePostLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :post_likes do |t|
      t.references :liker, null: false, foreign_key: { to_table: :users }
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
