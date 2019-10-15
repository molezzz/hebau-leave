json.partial! "users/user", user: @user
json.jwt_token @user.jwt_token if @user.jwt_token
