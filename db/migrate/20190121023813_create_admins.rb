class CreateAdmins < ActiveRecord::Migration[5.2]
  def change
    create_table :admins do |t|
      t.string :username
      t.string :password_digest
      t.datetime :last_sign_in_at
      t.string :last_sign_in_ip
      t.string :roles

      t.timestamps
    end
    add_index :admins, :username
  end
end
