class Api::V1::TradeMessagesController < ApplicationController
    before_action :authenticate_api_user!
    before_action :set_product

    def create
        @message = current_api_user.trade_messages.build(trade_messages_params)
        @message.product_id = @product.id
        if @message.save
            render json: { message: @message.as_json(include: { user: {only: [:id, :name, :avatar]} }) }
        else
            head :unprocessable_entity
        end
    end

    def destroy
        @message = TradeMessage.find_by(id: params[:id])
        if @message.destroy
            render json: @message
        else
            head :unprocessable_entity
        end
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
