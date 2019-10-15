class RecordsController < ApplicationController
  before_action :set_record, only: [:show, :edit, :update, :destroy]
  before_action :auth_user!, except: [:show]
  before_action :set_user, only: [:create]
  # GET /records
  # GET /records.json
  def index
    resource = current_admin ? Record : current_user.records
    @records = resource.ransack(params[:q]).result.page(params[:page]).per(params[:perpage]).order(created_at: :desc)
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
    count = current_user.records.where('begin_at > ?', Time.now.beginning_of_month).where('begin_at < ?', Time.now.end_of_month).count
    render json: {
      total: count
    }
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
      params.require(:record).permit(:user_id, :approver_id, :status, :begin_at, :end_at, :address, :tel, :cause, :agent, :agent_office, :agent_office_tel, :agent_mobile, :back_at, :unit_opinion, :leader_opinion, :remark)
    end
end
