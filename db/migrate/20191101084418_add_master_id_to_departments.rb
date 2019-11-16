class AddMasterIdToDepartments < ActiveRecord::Migration[5.2]
  def change
    add_column :departments, :master_id, :integer
    add_index :departments, :master_id
  end
end
