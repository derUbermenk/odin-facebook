class CreatePostShares < ActiveRecord::Migration[6.1]
  def change
    create_table :post_shares do |t|
      t.reference :user
      t.reference :post

      t.timestamps
    end
  end
end
