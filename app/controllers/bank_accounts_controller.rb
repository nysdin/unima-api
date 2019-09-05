class Api::V1::BankAccountsController < ApplicationController
    before_action :authenticate_api_user!

    def show
    end

    def update
        token = current_api_user.stripe_account_id
        head :forbidden and return if token.nil?

        begin 
            Stripe::Account.update(token, {external_account: params[:stripe_bank_token]})
        rescue => e
            head :bad_request and return
        end

        head :ok
    end

    def destroy
    end
end
