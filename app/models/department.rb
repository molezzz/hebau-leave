class Department < ApplicationRecord
    has_many :users
    belongs_to :master, class_name: 'User' 
    
    # admin 行政部门,edu 教学部门,party 党群部门, assistant 科研教辅, committee 机关党委
    enum category: {
        admin: 0,
        edu: 1,
        party: 2,
        assistant: 3,
        committee: 4
    }

end
