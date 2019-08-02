class Api::V1::CommentsController < ApplicationController
    before_action :authenticate_api_user!
    before_action :set_product
    
    def create
        @comment = current_api_user.comments.build(comment_params)
        @comment.product_id = @product.id
        if @comment.save
            render json: @product.comments
        else
            render json: :unprocessable_entity
        end
    end

    def destroy
    end

    private

        def comment_params
            params.permit(:content)
        end

        def set_product
            @product = Product.find_by(id: params[:product_id])
            head :not_found unless @product
        end
end
