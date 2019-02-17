json.partial! 'common/page', resources: @users
json.items @users do |user|
    json.partial! 'users/user', user: user
end
