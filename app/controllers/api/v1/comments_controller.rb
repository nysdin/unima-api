class Api::V1::CommentsController < ApplicationController
    before_action :authenticate_api_user!
    before_action :set_product
    before_action :correct_product_status, only: [:create]
    before_action :correct_user, only: [:destroy]
    
    def create
        @comment = current_api_user.comments.build(comment_params)
        @comment.product_id = @product.id
        if @comment.save
            render json: { comments: @comment.as_json(include: { user: {only: [:id, :name, :avatar]} }) }
        else
            head :unprocessable_entity
        end
    end

    def destroy
        @comment = Comment.find_by(id: params[:id])
        if @comment.destroy
            render json: @comment
        else
            head :unprocessable_entity
        end
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

        def correct_product_status
            head :forbidden unless @product.status == "open"
        end

end
