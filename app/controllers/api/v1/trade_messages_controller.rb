class Api::V1::TradeMessagesController < ApplicationController
    before_action :authenticate_api_user!
    before_action :set_product

    def create
    end

    def destroy
    end
end
