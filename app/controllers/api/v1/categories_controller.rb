module Api
    module V1
        class CategoriesController < ApplicationController
            before_action :set_categories, only: %i[index show]

            def index
                @categories = Category.all
            end

            def create
                if category_params
                    @category = Category.create(category_params)
                end
            end


            def show;
                @category = Category.find(params[:id])
            end

            def update
                @category = Category.find params[:id]
                @category.update category_params
                return render :show unless @category.invalid?

                render json: { errors: @category.errors.messages },
                       status: :unprocessable_entity
            end

            private
            def category_params
                params.require(:category).permit(:id,:name)
            end

            def set_categories
                @categories = Category.all
            end
        end
    end
end
