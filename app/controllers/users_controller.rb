class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.includes(:position,:department).ransack(params[:q]).result.page(params[:page]).per(params[:perpage])
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: { details: @user.errors }, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: { details: @user.errors }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def login
    code = params[:user][:code]
    result = Wechat.api.jscode2session code

    if !result['openid']
      render json: {
        error: :wrong_jscode,
        message: 'jscode 无效'
      }, status: :forbidden
      return
    end
    
    wechat = WechatSession.where(openid: result['openid']).first
    # 用户存在，直接登录
    if wechat && wechat.user
      @user = wechat.user
      @user.login
      render :show
      return
    end
    # 如果提供了手机号，查找手机号是否绑定了微信
    if params[:user][:mobile]
      @user = User.where(mobile: params[:user][:mobile].strip).first
      
      if !@user
        render json: {
          error: 'user_not_found',
          message: '您的手机号尚未在系统中登记，请联系管理员登记后登录'
        }, status: :unprocessable_entity
        return 
      end

      if @user.wechat_sessions.count > 0
        render json: {
          error: 'mobile_binded_openid',
          message: '手机号已绑定其他微信账号，请使用其他微信登录，或联系管理员解除绑定！' 
        }, status: :unprocessable_entity
        
        return
      end
      # 绑定session后完成登录
      if @user.bind_openid result['openid']
        @user.login
        render :show
        return
      else
        render json: {
          error: 'bind_openid_failed',
          message: '微信绑定失败，请联系管理员' 
        }, status: :unprocessable_entity
        return
      end
      
    end

    render json: {
      error: 'openid_not_found',
      message: '您还没有绑定手机号，请绑定手机号！',
      data: {
        openid: result['openid'],
        jscode: code
      }
    }, status: :not_found
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:position_id, :department_id, :realname, :mobile, :nickname, :avatar, :password, :job, :exdata, :last_sign_in_at, :last_sign_in_ip, :code)
    end
end
