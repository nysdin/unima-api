class Api::V1::CardsController < ApplicationController
    before_action :authenticate_api_user!

    def show
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
