module Api
    module V1
        class ProductsController < ApplicationController
            before_action :set_products, only: %i[index show]

            def index
                @products = Product.all
            end

            def create
                if product_params
                    @product = Product.create(product_params)
                end
            end


            def show;
                @product = Product.find(params[:id])
            end

            private
            def product_params
                params.require(:product).permit(:id,:name, :description, :stock, :tag, images_attributes: [:url])
            end

            def set_products
                @products = Product.all
            end
        end
    end
end
