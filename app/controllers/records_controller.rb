require 'csv'
class RecordsController < ApplicationController
  before_action :set_record, only: [:show, :edit, :update, :destroy, :back, :approval]
  before_action :auth_user!, except: [:show]
  before_action :set_user, only: [:create]
  # GET /records
  # GET /records.json
  def index
    resource = current_admin ? Record : current_user.records
    @records = resource.ransack(params[:q]).result.includes(:record_logs).page(params[:page]).per(params[:perpage]).order(created_at: :desc)
    respond_to do |format|
      format.json { render :index }
      format.csv do
        csv = CSV.generate(headers: true) do |csv|
          csv << %w{ID 姓名 职务 部门 部门审批人 分管校领导 请假天数 事由 外出地点 开始时间 结束时间 销假时间 申请时间 状态}
          @records.each do |record|
            approver = record.approver_on(:superior).try(:user)
            csv << [
              record.id,
              record.user.try(:job),
              record.user.try(:realname),
              record.user && record.user.department ? record.user.department.name : '',
              approver.try(:realname),
              record.user && record.user.department && record.user.department.master ? record.user.department.master.realname : '',
              (record.end_at.to_i - record.begin_at.to_i) / (60 * 60 * 24),
              record.cause,
              record.address,
              record.begin_at ? record.begin_at.strftime('%Y-%m-%d') : '',
              record.end_at ? record.end_at.strftime('%Y-%m-%d') : '',
              record.back_at ? record.back_at.strftime('%Y-%m-%d') : '',
              record.created_at.strftime('%Y-%m-%d'),
              record.status
            ]
          end
        end
        send_data csv.encode('gbk', :invalid => :replace, :undef => :replace, :replace => "?")
      end
    end
  end

  # GET /records/1
  # GET /records/1.json
  def show
    respond_to do |format|
      format.json { render :show }
      format.pdf {
        send_data @record.to_pdf, filename: "#{@record.user.realname}-#{@record.id}.pdf",disposition: 'inline'
      }
    end
  end

  # 统计已有的请假记录
  def count
    # 默认本月
    month = current_user.records.where('begin_at > ?', Time.now.beginning_of_month).where('begin_at < ?', Time.now.end_of_month).where('status >= ?', 0).count
    total = current_user.records.where('status > ?', 0).count
    unback = current_user.records.where('status > ?', 1).where('back_at is null').count
    render json: {
      total: total,
      month: month,
      unback: unback
    }
  end

  # 销假
  def back
    if @record.user.id == current_user.id
      
      if @record.update(record_params.merge(back_at: Time.now))
        render :show
      else
        render json: { error: 'record_save_error', message: '销假失败'}, status: :not_acceptable
      end
    else
      render json: { error: 'record_back_forbidden', message: '只允许本人销假'}, status: :forbidden
    end
  end

  def unreviewed
    department_ids = Department.where(master_id: current_user.id).pluck(:id)
    user_ids = User.where(department_id: department_ids).pluck(:id)
    @records = Record.where(user_id: user_ids).where(status: 0).page(params[:page])
    render :index
  end

  # GET /records/new
  def new
    @record = Record.new
  end

  # GET /records/1/edit
  def edit
  end

  # POST /records
  # POST /records.json
  def create
    @record = @user.records.new(record_params)

    respond_to do |format|
      if @record.save
        format.html { redirect_to @record, notice: 'Record was successfully created.' }
        format.json { render :show, status: :created, location: @record }
      else
        format.html { render :new }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /records/1
  # PATCH/PUT /records/1.json
  def update
    respond_to do |format|
      if @record.update(record_params)
        format.html { redirect_to @record, notice: 'Record was successfully updated.' }
        format.json { render :show, status: :ok, location: @record }
      else
        format.html { render :edit }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT 
  # 通过审批
  def approval
    result = false
    if @record.created? && @record.user && @record.user.department && @record.user.department.master_id == current_user.id
      result = @record.update(status: params[:status] || 1)
    end
    if result 
      render :show
    else
      render json: { error: 'approval_failed', message: '审批失败，请确保您有权处理！', status: :unprocessable_entity }
    end
  end

  # DELETE /records/1
  # DELETE /records/1.json
  def destroy
    @record.destroy
    respond_to do |format|
      format.html { redirect_to records_url, notice: 'Record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_record
      @record = Record.find(params[:id])
    end

    def set_user
      @user = current_admin ? User.find(params[:user_id]) : current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def record_params
      params.require(:record).permit(:user_id, :approver_id, :status, :begin_at, :end_at, :address, :tel, :cause, :agent, :agent_office, :agent_office_tel, :agent_mobile, :back_at, :unit_opinion, :leader_opinion, :remark, :back_lat, :back_lon)
    end
end
