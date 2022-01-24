class RemoveFriendsFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :friends
  end
end
