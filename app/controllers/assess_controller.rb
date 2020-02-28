class AssessController < ApplicationController
  layout 'assess'

  SMS_USER = ENV['SMS_USER']
  SMS_KEY = ENV['SMS_KEY']

  def index
    @projects = {
      dj: {
        name: '党建专项考核民主测评表',
        desc: '',
        kind: 'dj',
        items: [],
        choice: [
          {label: '优秀', val: 1000 },
          {label: '良好', val: 800 },
          {label: '一般', val: 600 },
          {label: '较差', val: 300 }
        ],
        votes: {}
      },
      bz: {
        name: '处级班子考核民主测评表',
        desc: '',
        kind: 'bz',
        items: [],
        choice: [
          {label: '优秀', val: 100 },
          {label: '良好', val: 80 },
          {label: '一般', val: 60 },
          {label: '较差', val: 30 }
        ],
        votes: {}
      },
      gb: {
        name: '处级干部考核民主测评表',
        desc: '',
        kind: 'gb',
        items: [],
        choice: [
          {label: '优秀', val: 100 },
          {label: '称职', val: 80 },
          {label: '基本称职', val: 60 },
          {label: '不称职', val: 30 }
        ],
        votes: {}
      },
      lz: {
        name: '处级干部廉政考核民主测评表',
        desc: '',
        kind: 'lz',
        items: [],
        choice: [
          {label: '优秀', val: 100 },
          {label: '良好', val: 80 },
          {label: '一般', val: 60 },
          {label: '较差', val: 30 }
        ],
        votes: {}
      }
    }
    @vote_member = VoteMember.where(code: params[:code]).first
    if @vote_member.nil?
      render
      return
    end
    if  @vote_member.kind.include? 'dj'
      #党群和行政的党建单独打，打给机关党委
      #继续教育学院和研究生院属于行政，但是有自己的党委
      unit = @vote_member.kind.split('-')[1]
      if unit
        dep = Department.select('id,name,party').where(name: unit == 'yjs' ? '研究生学院' : '继续教育学院')
      else
        dep = Department.select('id,name,party').where(category: 4)
      end
      @projects[:dj][:items] = dep.map {|d| { name: d.party, id: d.id }}
    elsif @vote_member.kind  ==  'hp'
      #互评逻辑
      #党群给党群、教学、教辅打，其中打给党群部门的算该部门的自评
      #行政给行政、教学、教辅打，其中打给行政部门的算该部门的自评
      #该步骤先组织
      categories = [0,2].include?(@vote_member.category) ? [1,3] : [0,2]
      dep = Department.select('id,name').where(category: categories)
      @projects[:bz][:items] = dep.map {|d| { name: d.name, id: d.id }}
      @projects[:gb][:items] = User.order(weight_hp: :asc).includes(:department).where(department_id: dep.collect{|d| d.id }).select('id, realname, department_id ,job').all.map {|u| {name: u.realname, job: u.job, id: u.id, department: u.department.name }}
      # 今年不考核廉政
      # @projects[:lz][:items] = @projects[:gb][:items]
    else
      #自评逻辑
      #只有教学和教辅进行自评
      #自评同时打党建的票
      dep = Department.select('id,name,party').where(id: @vote_member.department_id)
      @projects[:dj][:items] = dep.map {|d| { name: d.party, id: d.id }}
      @projects[:bz][:items] = dep.map {|d| { name: d.name, id: d.id }}
      @projects[:gb][:items] = User.includes(:department).where(department_id: dep.collect{|d| d.id }).select('id, realname, department_id ,job').all.map {|u| {name: u.realname, job: u.job, id: u.id, department: u.department.name }}
      # 今年不考核廉政
      # @projects[:lz][:items] = @projects[:gb][:items]
    end
  end

  def save_votes
    data = params[:votes].permit!
    member = VoteMember.where(code: params[:code]).first
    now = Time.now
    render(json: { error: true, message: '您已经参与过了！' }) && return if member.vote_at
    department_votes = data[:bz].to_h.map do |k, v|
      VoteResult.new(code: member.code, kind: member.kind, sheet: :bz, department_id: k, score: v, created_at: now, updated_at: now)
    end
    member_votes = [:gb, :lz].collect do |sheet|
      data[sheet].to_h.map do |k, v|
        VoteResult.new(code: member.code, kind: member.kind, sheet: sheet, user_id: k, score: v, created_at: now, updated_at: now)
      end
    end.flatten
    VoteResult.import department_votes + member_votes
    member.update_attributes(ip: request.remote_ip, ua: request.user_agent, vote_at: now)
    render json: {message: '保存成功！'}
  end

  def generate_codes
    kind = params[:kind]
    if kind == 'hp'
      category = params[:category].to_i
      render(json: { error: true, message: '请选择正确的部门类别' }) && return unless [0,1,2,3].include? category
      codes = params[:mobiles].split(',').map do |m|
        VoteMember.new(mobile: m, code: SecureRandom.hex(8), kind: kind, category: category)
      end
      result = VoteMember.import codes
      render json: { failed: result.failed_instances.map{|ins| ins.mobile }}
    else
      codes = params[:mobiles].split(',').map do |m|
        VoteMember.new(mobile: m, code: SecureRandom.hex(8), kind: kind, department_id: params[:department])
      end
      result = VoteMember.import codes
      render json: { failed: result.failed_instances.map{|ins| ins.mobile }}
    end
  end

  def send_code_list
    kind = params[:kind]
    if kind == 'hp'
      codes = VoteMember.where(kind: kind, category: params[:category])
    else
      codes = VoteMember.where(kind: kind, department_id: params[:department])
    end
    codes = codes.where('send_at is null')
    render json: codes.to_json
  end

  def send_codes
    tpl = '42016'
    codes = VoteMember.where(id: params[:codes])
    now = Time.now
    begin
      codes.each do |code|
        params = {smsUser: SMS_USER, templateId: tpl,  msgType: '0', phone: code.mobile, vars: {code: code.code}.to_json}
        resp = Faraday.post 'https://www.sendcloud.net/smsapi/send', {
          smsUser: SMS_USER,
          msgType: params[:msgType],
          templateId: tpl,
          phone: code.mobile,
          vars: params[:vars],
          signature: generate_signature(params)
        }
        result = JSON.parse resp.body
        Rails.logger.debug result
        if result['result']
          code.update_attributes(send_at: now)
        else
          raise result['message'] + " - 最后发送的手机号：#{code.mobile}"
        end
      end
    rescue Exception => e
      render json: {error: true, message: e.message}
      return
    end       
    render json: { message: '发送完成' }
  end

  private

  # 生成API验证参数
  def generate_signature(params)
    sorted_params = Hash[params.sort_by{|key, val| key}]
    params_str = sorted_params.inject([]){|array, (key, val)| array << [key, val].join('=')}.join('&')
    Digest::MD5.hexdigest([SMS_KEY, params_str, SMS_KEY].join('&'))
  end
end
