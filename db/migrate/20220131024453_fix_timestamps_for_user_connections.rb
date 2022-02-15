class FixTimestampsForUserConnections < ActiveRecord::Migration[6.1]
  def change
    change_table :user_connections do |t|
      t.rename :created_at, :sent_at
      t.rename :updated_at, :accepted_at
    end
  end
end
