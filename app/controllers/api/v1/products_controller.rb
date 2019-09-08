class Api::V1::ProductsController < ApplicationController
    before_action :authenticate_api_user!, except: [:index, :show, :search]
    before_action :correct_user, only: [:update, :destroy]
    before_action :trading_or_close_product, only: [:update]
    before_action :trading_user, only: [:trading]
    before_action :buyer_user, only: [:complete]

    def index 
        @products = Product.all

        render json: @products
    end

    def show
        @product = Product.find_by(id: params[:id])
        
        if @product
            @comments = @product.comments
            like = current_api_user&.liking?(@product)

            render json: {
                like: like,
                product: @product.as_json(include: {
                    seller: { only: [:name, :avatar]},
                    category: { methods: :path }
                }),
                comments: @comments.as_json(include: { user: {only: [:name, :id, :avatar]}})
            }
        else
            head :not_found 
        end
    end

    def search
        @q = Product.ransack(params[:q])
        @products = @q.result
        render json: @products
    end

    def create 
        @category = Category.find_by(name: category_params[:category])
        @product = current_api_user.sell_products.build(product_params)
        @product.category_id = @category.id if @category

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
    
    #商品の取引を開始
    def trade
        @product = Product.find_by(id: params[:id])

        head :forbidden and return if current_api_user == @product.seller
        if @product.update_attributes(buyer_id: current_api_user.id, status: "trade", traded_at: Time.zone.now)
            render json: @product
        else
            render json: @product.errors, status: :unprocessable_entity
        end
    end

    #取引を完了
    def complete
        if @product.update_attributes(status: "close", closed_at: Time.zone.now)
            head :ok
        else
            render json: @product.errors, status: :unprocessable_entity
        end 
    end

    #取引中の商品を返す
    def trading
        if @product
            @messages = @product.trade_messages
            like = current_api_user&.liking?(@product)

            render json: {
                like: like,
                product: @product.as_json(include: {
                    seller: { only: [:name, :avatar]},
                    category: { methods: :path }
                }),
                messages: @messages.as_json(include: { user: {only: [:name, :id, :avatar]}})
            }
        else
            head :not_found 
        end
    end

    #購入手続き画面の情報を出力
    def confirmation
        @product = Product.find_by(id: params[:id])

        if @product
            customer_id = current_api_user.stripe_customer_id

            if customer_id.nil?
                render json: { product: @product }
            else
                begin
                    customer = Stripe::Customer.retrieve(customer_id)
                    data = customer[:sources][:data][0]
                    last4 = data[:last4]
                    exp_month = data[:exp_month]
                    exp_year = data[:exp_year]
                    brand = data[:brand]
                    cregit = {last4: last4, exp_month: exp_month, exp_year: exp_year, brand: brand}
                    render json: { product: @product, card: cregit }
                rescue => e
                    head :bad_request
                end
            end
        else
            head :not_found
        end
    end

    private 

        def product_params 
            params.permit(:name, :description, :price, :state, { images: [] })
        end

        def category_params
            params.permit(:category)
        end

        #売り手かどうか
        def correct_user 
            @product = Product.find_by(id: params[:id])
            head :forbidden if current_api_user == !@product.seller
        end

        #取引に関わるユーザーかどうか
        def trading_user
            @product = Product.find_by(id: params[:id])
            haed :forbidden unless current_api_user == @product.buyer || current_api_user == @product.seller
        end

        #買い手かどうか
        def buyer_user
            @product = Product.find_by(id: params[:id])
            head :forbidden unless current_api_user == @product.buyer
        end

        #商品が公開中でなければダメ
        def trading_or_close_product
            @product = Product.find_by(id: params[:id])
            head :forbidden if @product.status == "trade" || @product.status == "close"
        end

end
