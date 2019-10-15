class CreateRecordLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :record_logs do |t|
      t.integer :record_id
      t.integer :kind, default: 0

      t.timestamps
    end
    add_index :record_logs, :record_id
  end
end
