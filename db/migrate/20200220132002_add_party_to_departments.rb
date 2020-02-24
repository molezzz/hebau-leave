class AddPartyToDepartments < ActiveRecord::Migration[5.2]
  def change
    add_column :departments, :party, :string
    add_column :departments, :sn, :integer
  end
end
