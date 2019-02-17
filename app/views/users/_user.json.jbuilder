json.extract! user, :id, :realname, :mobile, :nickname, :avatar, :bind_wechat, :job, :last_sign_in_at, :last_sign_in_ip, :created_at, :updated_at
json.position do
    json.partial! 'positions/position', position: user.position 
end if user.position
json.department do
    json.partial! 'departments/department', department: user.department 
end if user.department
json.url user_url(user, format: :json)
