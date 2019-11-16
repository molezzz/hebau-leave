class User < ApplicationRecord
    has_secure_password

    has_many :wechat_sessions
    has_many :records
    has_many :approved_records, foreign_key: :approver_id, class_name: 'User'
    
    belongs_to :department
    belongs_to :position
    has_many :own_departments, foreign_key: :master_id, class_name: 'Department'

    attr_accessor :jwt_token

    validates :mobile, uniqueness: true

    before_validation :trim_mobile

    HMAC_SECRET = ENV['JWT_SECRET'] || 'hebau-leave-secret'

    class << self 
        def token_decode(token)
					begin
						payload, alg = JWT.decode token, HMAC_SECRET, true, { algorithm: 'HS256' }
						payload
					rescue => e #JWT::ExpiredSignature || JWT::VerificationError
						Rails.logger.warn "JWT payload decode error! error: #{e}"
						nil
					end
        end

				def from_token(token)
					decoded_token = token_decode token
					return nil if !decoded_token
					user = User.where(id: decoded_token['id']).first
        end
    end

    def trim_mobile
			self.mobile = self.mobile.strip
    end

    def bind_openid(openid)
			self.wechat_sessions.create(openid: openid)
    end
    
    def login
			self.jwt_token = JWT.encode({ id: self.id },HMAC_SECRET, 'HS256')
			self
    end

    
end
