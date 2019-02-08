class CreateDepartments < ActiveRecord::Migration[5.2]
  def change
    create_table :departments do |t|
      t.integer :parent_id,default: 0, null: false
      t.string :name
      t.integer :category, default: 0, null: false

      t.timestamps
    end
    add_index :departments, :parent_id
  end
end
