class Api::V1::BankAccountsController < ApplicationController
    before_action :authenticate_api_user!

    def show
        account_id = current_api_user.stripe_account_id

        if account_id.nil?
            head :not_found
        else
            begin
                account = Stripe::Account.retrieve(account_id)
                render_bank_account(account)
            rescue => e
                head :bad_request and return
            end
        end
    end

    def update
        account_id = current_api_user.stripe_account_id
        head :forbidden and return if account_id.nil?

        begin 
            account = Stripe::Account.update(account_id, {external_account: params[:stripe_bank_token]})
            render_bank_account(account)
        rescue => e
            head :bad_request and return
        end
    end

    def destroy
    end

    private

        def render_bank_account(account)
            data = account[:external_accounts][:data][0]
            full_name = data[:account_holder_name]
            bank_name = data[:bank_name]
            last4 = data[:last4]
            routing_number = data[:routing_number]
            bank_data = { full_name: full_name, bank_name: bank_name, last4: last4, routing_number: routing_number}
            render json: bank_data
        end

end
