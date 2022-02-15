class CreateUserConnections < ActiveRecord::Migration[6.1]
  def change
    create_table :user_connections do |t|
      t.references :initiator, index: true, foreign_key: { to_table: :users }
      t.references :recipient, index: true, foreign_key: { to_table: :users }
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
