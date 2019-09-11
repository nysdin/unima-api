class Api::V1::UsersController < ApplicationController
    before_action :authenticate_api_user!, except: [:validate_account]

    def validate_account
        @user = User.new(user_params)
        if @user.valid?
            head :ok
        else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity	
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

    def bank
        token = current_api_user.stripe_account_id
        head :forbidden and return if token.nil?

        begin 
            Stripe::Account.update(token, {external_account: params[:stripe_bank_token]})
        rescue => e
            head :bad_request and return
        end

        head :ok
    end

    private

        def user_params
            params.permit(:name, :email, :password, :password_confirmation)
        end

end
