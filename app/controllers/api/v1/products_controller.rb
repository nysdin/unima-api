class Api::V1::ProductsController < ApplicationController
    before_action :authenticate_api_user!, only: [:create, :update, :destroy]
    before_action :correct_user, only: [:update, :destroy]

    def index 
        @products = Product.all

        render json: @products
    end

    def show
        @product = Product.find_by(id: params[:id])
        
        if @product
            render json: @product
        else
            head :not_found 
        end
    end

    def create 
        @product = current_api_user.products.build(product_params)

        if @product.save 
            render json: @product, status: :created
        else
            render json: @product.errors, status: :unprocessable_entity
        end
    end

    def update
        if @product.update(product_params)
            render json: @product
        else
            render json: @product.errors, status: :unprocessable_entity
        end
    end

    def destroy
        if @product.destroy
            render json: @product
        else
            head :internal_server_error
        end
    end

    private 

        def product_params 
            params.permit(:name, :description, :price, :state, :category)
        end

        def correct_user 
            @product = current_api_user.products.find_by(id: params[:id])
            head :forbidden if @product.nil?
        end
end
