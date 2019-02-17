class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer :position_id
      t.integer :department_id
      t.string :realname
      t.string :mobile
      t.string :nickname
      t.string :avatar
      t.string :password_digest
      t.string :job
      t.boolean :bind_wechat, default: false, null: false
      t.text :exdata
      t.datetime :last_sign_in_at
      t.string :last_sign_in_ip

      t.timestamps
    end
    add_index :users, :position_id
    add_index :users, :department_id
    add_index :users, :realname
    add_index :users, :mobile, unique: true
  end
end
