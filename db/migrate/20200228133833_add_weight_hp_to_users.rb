class AddWeightHpToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :weight_hp, :integer
  end
end
