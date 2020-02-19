class CreateVoteResults < ActiveRecord::Migration[5.2]
  def change
    create_table :vote_results do |t|
      t.string :kind
      t.string :sheet
      t.integer :department_id
      t.integer :user_id
      t.string :code
      t.integer :score

      t.timestamps
    end
    add_index :vote_results, :kind
    add_index :vote_results, :department_id
    add_index :vote_results, :user_id
  end
end
