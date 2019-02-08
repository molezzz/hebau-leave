json.extract! admin, :id, :username, :last_sign_in_at, :last_sign_in_ip, :roles, :created_at, :updated_at
json.url admin_url(admin, format: :json)
