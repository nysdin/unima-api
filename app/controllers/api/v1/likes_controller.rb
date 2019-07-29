class Api::V1::LikesController < ApplicationController
  before_action :authenticate_api_user!

  def create
    @product = Product.find_by(id: params[:product_id])
    if @product && !current_api_user.liking?(@product)
      current_api_user.like(@product)
      render json: @product
    else
      head :not_found
    end
  end

  def destroy
    @product = Product.find_by(id: params[:product_id])
    if @product && current_api_user.liking?(@product)
      current_api_user.unlike(@product)
      render json: @product.reload
    else
      head :not_found
    end
  end
end
