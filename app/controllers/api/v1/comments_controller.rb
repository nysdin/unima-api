class Api::V1::CommentsController < ApplicationController
    before_action :authenticate_api_user!
    before_actin :correct_user, only: [:destroy]
    before_action :set_product
    
    def create
        @comment = current_api_user.comments.build(comment_params)
        @comment.product_id = @product.id
        if @comment.save
            render json: { comments: @comment.as_json(include: { user: {only: [:id, :name]} }) }
        else
            head :unprocessable_entity
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

        def correct_user
            head :forbidden unless current_api_user == @product.seller
        end

end
