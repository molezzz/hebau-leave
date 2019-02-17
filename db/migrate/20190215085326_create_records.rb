class CreateRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :records do |t|
      t.integer :user_id
      t.integer :approver_id
      t.integer :status, default: 0
      t.datetime :begin_at
      t.datetime :end_at
      t.string :address
      t.string :tel
      t.text :cause
      t.string :agent
      t.string :agent_office
      t.string :agent_office_tel
      t.string :agent_mobile
      t.datetime :back_at
      t.text :exdata

      t.timestamps
    end
    add_index :records, :user_id
    add_index :records, :approver_id
    add_index :records, :begin_at
    add_index :records, :end_at
    add_index :records, :agent
  end
end
