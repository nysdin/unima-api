class Api::V1::BankAccountsController < ApplicationController
    before_action :authenticate_api_user!

    def show
        account_id = current_api_user.stripe_account_id

        if account_id.nil?
            head :ok
        else
            begin
                account = Stripe::Account.retrieve(account_id)
                data = account[:external_accounts][:data][0]
                full_name = data[:account_holder_name]
                bank_name = data[:bank_name]
                last4 = data[:last4]
                routing_number = data[:routing_number]
                bank_data = { full_name: full_name, bank_name: bank_name, last4: last4, routing_number: routing_number}
                render json: bank_data
            rescue => e
                head :bad_request and return
            end
        end
    end

    def update
        account_id = current_api_user.stripe_account_id
        head :forbidden and return if account_id.nil?

        begin 
            Stripe::Account.update(account_id, {external_account: params[:stripe_bank_token]})
        rescue => e
            head :bad_request and return
        end

        head :ok
    end

    def destroy
    end
end
