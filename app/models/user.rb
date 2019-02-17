class User < ApplicationRecord
    has_secure_password

    has_many :wechat_sessions
    has_many :records
    has_many :approved_records, foreign_key: :approver_id, class_name: 'User'
    
    belongs_to :department
    belongs_to :position


    validates :mobile, uniqueness: true

    before_validation :trim_mobile
    def trim_mobile
        self.mobile = self.mobile.strip
    end
    
end
