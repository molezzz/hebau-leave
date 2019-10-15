class ApplicationController < ActionController::Base
  include Knock::Authenticable

  protected

  def current_user
    User.from_token get_jwt_token
  end

  def auth_user!
    if !current_user && !current_admin
      render json: {error: 'login_required', message: '请登录后使用！'}, status: :unauthorized
      return false
    end
  end

  def get_jwt_token
    token = request.headers['Authorization'] || ''
    bearer, jwt = token.split(' ')
    return nil if bearer != 'Bearer'
    jwt
  end

end
