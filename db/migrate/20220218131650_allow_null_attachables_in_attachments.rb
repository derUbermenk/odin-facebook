class AllowNullAttachablesInAttachments < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        change_column_null(:attachments, :attachable_id, true)
      end

      dir.down do
        change_column_null(:attachments, :attachable_id, false)
      end
    end
  end
end
