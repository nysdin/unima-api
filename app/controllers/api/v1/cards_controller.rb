class Api::V1::CardsController < ApplicationController
    before_action :authenticate_api_user!

    def show
        token = current_api_user.stripe_customer_id
        if token.nil?
            head :ok
        else
            begin
                customer = Stripe::Customer.retrieve(token)
                data = customer[:sources][:data][0]
                last4 = data[:last4]
                exp_month = data[:exp_month]
                exp_year = data[:exp_year]
                brand = data[:brand]
                cregit = {last4: last4, exp_month: exp_month, exp_year: exp_year, brand: brand}
                render json: cregit
            rescue => e
                head :bad_request and return
            end
        end
    end

    def update
        token = current_api_user.stripe_customer_id

        if token.nil?
            begin
                cutomer = Stripe::Customer.create({
                    source: params[:stripe_cregit_token],
                    email: current_api_user.email,
                })
                current_api_user.stripe_customer_id = cutomer.id
            rescue => e
                head :bad_request and return
            end
        else
            begin
                Stripe::Customer.update(token, {
                    source: params[:stripe_cregit_token],
                })
            rescue => e
                head :bad_request and return
            end
        end

        head :ok
    end 

    def destroy
    end
end
