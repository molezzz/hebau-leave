class VoteMember < ApplicationRecord
  KIND = [:zp, :hp] #自评、互评
  CATE = [0,1,2,3] #对应 department admin 行政部门,edu 教学部门,party 党群部门, assistant 科研教辅
  
  def self.import_members
    parts = Hash[Department.select('id,name').all.map{|d| [d.name, d.id]}]
    csv =  File.readlines "#{Rails.root}/tmp/members.csv"
    csv.each_with_index do |line, idx|
      m = line.split(',')
      m = User.new(weight: m[0],realname: m[1], department_id: parts[m[2]],job: m[3], position_id: m[4].to_i, password: '12345678', mobile: "120#{idx}")
      p m.to_json
      p m.save
      p m.errors
    end
  end

end
