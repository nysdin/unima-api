class Api::V1::CardsController < ApplicationController
    before_action :authenticate_api_user!

    def show
        customer_id = current_api_user.stripe_customer_id
        if customer_id.nil?
            head :not_found
        else
            begin
                customer = Stripe::Customer.retrieve(customer_id)
                render_card(customer)
            rescue => e
                head :bad_request and return
            end
        end
    end

    def update
        customer_id = current_api_user.stripe_customer_id
        if customer_id.nil?
            begin
                customer = Stripe::Customer.create({
                    source: params[:stripe_cregit_token],
                    email: current_api_user.email,
                })
                if current_api_user.update_attributes(stripe_customer_id: customer.id)
                    render_card(customer)
                else
                    head :unprocessable_entity
                end
            rescue => e
                head :bad_request and return
            end
        else
            begin
                customer = Stripe::Customer.update(customer_id, {
                    source: params[:stripe_cregit_token],
                })
                render_card(customer)
            rescue => e
                head :bad_request and return
            end
        end
    end 

    def destroy
        customer_id = current_api_user.stripe_customer_id
        
        if customer_id.nil?
            head :not_found
        else
            begin
                customer = Stripe::Customer.retrieve(customer_id)
                card_id = customer[:sources][:data][0][:id]
                Stripe::Customer.delete_source(
                    customer_id,
                    card_id,
                )
                head :ok
            rescue => e
                head :bad_request and return
            end
        end
    end

    private

        def render_card(customer)
            if customer[:default_source]
                data = customer[:sources][:data][0]
                last4 = data[:last4]
                exp_month = data[:exp_month]
                exp_year = data[:exp_year]
                brand = data[:brand]
                cregit = {last4: last4, exp_month: exp_month, exp_year: exp_year, brand: brand}
                render json: cregit
            else
                head :ok
            end
        end
end
