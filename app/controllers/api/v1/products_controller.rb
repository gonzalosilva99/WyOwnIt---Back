module Api
    module V1
        class ProductsController < ApplicationController

            def index
                @products = Product.all.with_attached_images

                render json: @products.map { |product|
                    product.images.map { |image|
                        product.as_json.merge({ images: url_for(image) })
                    }
                }
            end

            def create
                if params[:product]
                    @product = Product.create! params.require(:product).permit(:name, :description)
                    @product.images.attach(product_params[:images])
                end
            end

            private
            def product_params
                params.require(:product).permit(:name, :description, :images)
            end

        end
    end
end
