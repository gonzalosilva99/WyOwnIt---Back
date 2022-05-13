module Api
    module V1
        class ProductsController < ApplicationController
            before_action :set_products, only: %i[index show]

            def index
                if params[:search]
                    @products = Product.where("UPPER(name) like ?", "%#{params[:search].upcase}%")
                else
                    @products = Product.all
                end
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
                @product.images.delete_all
                @product.save
                @product.update product_params
                return render :show unless @product.invalid?

                render json: { errors: @product.errors.messages },
                       status: :unprocessable_entity
            end

            private
            def product_params
                params.require(:product).permit(:id,:name, :description, :stock, :current_stock, :tag, :category_id, images_attributes: [:url, :cloudinary_id])
            end

            def set_products
                @products = Product.all
            end
        end
    end
end
