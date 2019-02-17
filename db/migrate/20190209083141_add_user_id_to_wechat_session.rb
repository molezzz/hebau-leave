class AddUserIdToWechatSession < ActiveRecord::Migration[5.2]
  def change
    add_column :wechat_sessions, :user_id, :integer
    add_index :wechat_sessions, :user_id
  end
end
