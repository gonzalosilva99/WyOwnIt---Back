module Api
    module V1
        class OrdersController < ApplicationController
            before_action :set_orders, only: %i[index show]
            before_action :authenticate_user
            load_and_authorize_resource

            def index
                page = params[:page] ? params[:page] : 1
                limit = params[:limit] ? params[:limit] : 10
                @orders = {}
                if @current_customer 
                    @orders = @current_customer.orders.paginate(:page => page, :per_page => limit)
                elsif @current_admin   
                    @orders = Order.paginate(:page => page, :per_page => limit)
                end
                @orders
                
            end

            def show;
                @order = Order.find(params[:id])
            end

            def create
                @order = Order.create!(order_params.merge(user: @current_user, status: "pending"))
                @order.save
            end

            def update 
                @order = Order.find params[:id]
                @order.update order_params
                return render :show unless @order.invalid?

                render json: { errors: @order.errors.messages },
                       status: :unprocessable_entity
            end 

            private
            def order_params
                params.require(:order)
                      .permit(:id, :date, :created_at, :status, :days,
                              order_products_attributes: [:product_id, :units ]
                    )
            end
            
            def set_orders
                @orders = Order.all
            end
        end
    end
end