class CmcController < ApplicationController
    before_action :authenticate_admin, except: [:index]

    def logout
        render json: {success: true}
    end

    def user_info
        render json: {
            roles: ['admin'],
            name: 'mole',
            avatar: 'https://iph.href.lu/80x80?text=avatar&bg=ADE96E'
        }
    end
end
