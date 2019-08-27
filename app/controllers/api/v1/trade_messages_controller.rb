class Api::V1::TradeMessagesController < ApplicationController
    before_action :authenticate_api_user!
    before_action :set_product

    def create
    end

    def destroy
    end

    private

        def trade_messages_params
            params.permit(:content)
        end

        def set_product
            @product = Product.find_by(id: params[:product_id])
            head :not_found unless @product
        end
end
