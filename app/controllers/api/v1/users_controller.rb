class Api::V1::UsersController < ApplicationController
    before_action :authenticate_api_user!, except: [:validate_account, :address]

    def validate_account
        @user = User.new(user_params)
        if @user.valid?
            head :ok
        else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity	
        end
    end

    def address
        query = params[:zipcode]
        uri = URI.parse('http://zipcloud.ibsnet.co.jp/api/search?zipcode=' + query)
        res = Net::HTTP.start(uri.host, uri.port){ |http| 
            http.get(uri.request_uri)
        }
        
        if res.code === '200'
            result = JSON.parse(res.body)
            render json: result
        else
            head :ok
        end
    end

    def sell
        @products = current_api_user.sell_products
        render json: @products
    end

    def purchase
        @products = current_api_user.buy_products
        render json: @products
    end

    def like
        @products = current_api_user.like_products
        render json: @products
    end

    private

        def user_params
            params.permit(:name, :email, :password, :password_confirmation)
        end

end
