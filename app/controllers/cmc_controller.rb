class CmcController < ApplicationController
    before_action :authenticate_admin, except: [:index]

    def logout
        render json: {success: true}
    end

    def user_info
        render json: {
            roles: ['admin'],
            name: 'mole',
            avatar: 'https://avatars3.githubusercontent.com/u/787294?s=460&v=4'
        }
    end
end
