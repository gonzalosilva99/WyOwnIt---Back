module Api
    module V1
        class ProductsController < ApplicationController
            before_action :set_products, only: %i[index show]

            def index
                @products = Product.all
            end

            def create
                if product_params
                    @product = Product.create(product_params.merge(current_stock: product_params[:stock]))
                    return render :show unless @product.invalid?

                    render json: { errors: @product.errors.messages },
                        status: :unprocessable_entity
                end
            end


            def show;
                @product = Product.find(params[:id])
            end

            def update
                @product = Product.find params[:id]
                @product.update product_params
                return render :show unless @product.invalid?

                render json: { errors: @product.errors.messages },
                       status: :unprocessable_entity
            end

            private
            def product_params
                params.require(:product).permit(:id,:name, :description, :stock, :current_stock, :tag, :category_id, images_attributes: [:url])
            end

            def set_products
                @products = Product.all
            end
        end
    end
end
