class Api::V1::ProductsController < ApplicationController
    before_action :authenticate_api_user!, only: [:create, :update, :destroy]

    def index 
        @products = Product.all

        render json: @products
    end

    def create 
        @product = current_api_user.products.build(product_params)

        if @product.save 
            render json: @product, status: :created
        else
            render json: product.errors, status: :unprocessable_entity
        end
    end

    def show
        @product = Product.find_by(id: params[:id])
        
        if @product
            render json: @product
        else
            head :not_found 
        end
    end

    def update
        @product = current_api_user.products.find_by(id: params[:id])
        if @product.update(product_params)
            render json: @product
        else
            render json: product.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @product = current_api_user.product.find_by(id: params[:id])
        if @product.destory
            render json: { status: 200 }
        else
            render json: { status: :unprocessable_entity }
        end
    end

    private 

        def product_params 
            params.permit(:name, :description, :price, :state, :category)
        end
end
