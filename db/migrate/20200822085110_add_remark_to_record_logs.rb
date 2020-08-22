class AddRemarkToRecordLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :record_logs, :user_id, :integer
    add_column :record_logs, :remark, :text
  end
end
