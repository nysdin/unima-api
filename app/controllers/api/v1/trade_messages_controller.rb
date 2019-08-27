class Api::V1::TradeMessagesController < ApplicationController
    before_action :authenticate_api_user!
    before_action :set_product
    before_action :correct_user
    before_action :correct_product_status

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
        if  current_api_user == @message.user
            if @message.destroy
                render json: @message
            end
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

        def correct_user
            unless current_api_user == @product.seller || current_api_user == @product.buyer
                head :forbidden
            end
        end

        def correct_product_status
            head :forbidden unless @product.status == "trade"
        end
end
