class CmcController < ApplicationController
    skip_before_action :verify_authenticity_token

    def login
        render json: {token: '123456'}
    end

    def user_info
        render json: {
            roles: ['admin'],
            name: 'mole',
            avatar: 'https://avatars3.githubusercontent.com/u/787294?s=460&v=4'
        }
    end
end
