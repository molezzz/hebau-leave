class CreateVoteMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :vote_members do |t|
      t.string :mobile
      t.string :code
      t.string :kind
      t.integer :category
      t.integer :department_id
      t.text :ua
      t.string :ip
      t.datetime :vote_at
      t.datetime :send_at

      t.timestamps
    end
    add_index :vote_members, :department_id
    add_index :vote_members, :code,unique: true
  end
end
