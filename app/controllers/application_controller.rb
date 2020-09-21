class ApplicationController < ActionController::Base
  include Knock::Authenticable
  before_action :verify_request

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

  def verify_request
    token = access_token
    render json: {message: 'Token required', success: false, code: 'common.authorization_timeout'}, status: :forbidden if token.blank?
  end

  def access_token
    token = params[:acctk] || request.headers['x-acc-token']
    return nil if token.blank?
    begin
      decoded_token = JWT.decode token, 'hebau-weapp', true, { algorithm: 'HS256' }
    rescue JWT::DecodeError => e
      Rails.logger.warn "JWT decode error: #{e.message}"
      return nil
    end
  end

end
