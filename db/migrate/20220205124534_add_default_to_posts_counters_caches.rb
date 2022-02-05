class AddDefaultToPostsCountersCaches < ActiveRecord::Migration[6.1]
  def change
    change_table :posts do |t|
      t.change :attachments_count, :integer, default: 0 
      t.change :attaches_count, :integer, default: 0
    end
  end
end
