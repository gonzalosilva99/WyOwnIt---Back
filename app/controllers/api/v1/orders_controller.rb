module Api
    module V1
        class OrdersController < ApplicationController
            before_action :set_orders, only: %i[index show]
            before_action :authenticate_user
            load_and_authorize_resource

            def index
                page = params[:page] ? params[:page] : 1
                limit = params[:limit] ? params[:limit] : 10
                sort_by = 'id'
                sort_by = params[:sort_by] if params[:sort_by]
                order = 'asc'
                order = params[:order_type] if params[:order_type]
                @orders = {}

                if @current_customer 
                    @orders = @current_customer.orders.paginate(:page => page, :per_page => limit).order(sort_by + ' ' + order.upcase)
                elsif @current_admin   
                    @orders = Order.paginate(:page => page, :per_page => limit).order(sort_by + ' ' + order.upcase)
                end
                if params[:search]
                    @orders = @orders.where("CAST(id AS TEXT) like ?", "%#{params[:search]}%").order(sort_by + ' ' + order.upcase)
                end
                if params[:status]
                    @orders = @orders.where(status: params[:status])
                end
                @orders
            end

            def show;
                @order = Order.find(params[:id])
            end

            def create
                @order = Order.create!(order_params.merge(user: @current_user, status: "pending"))
                message = 'Your new order has been created, check "My orders" to see it.'
                Notification.create(title: 'Order created', message: message, user: @order.user, seen: false)
                NotificationMailer.with(message: message, addressee: @current_user.email).new_notification_email.deliver_now
                @order.save
            end

            def update 
                @order = Order.find params[:id]
                @order.update order_params
                Notification.create(title: 'Order updated',message: 'The order of ' + @order.created_at.strftime("%Y-%m-%d") + ' has been updated.', user: @order.user, seen: false)
                return render :show unless @order.invalid?

                render json: { errors: @order.errors.messages },
                       status: :unprocessable_entity
            end 

            def stats 
                products = Stripe::Product.list({limit: 20}).data
                subscriptions = Stripe::Subscription.list({status: 'active'})
                
                #get # of pending orders 
                @current_orders = Order.where.not(status: 'approved', status: 'denied').count

                #get # of subscriptions
                @users_per_product = {}
                get_users_per_product(products, subscriptions) 

                #get new subscriptors and orders 
                @new_subscriptors = Customer.where("created_at > ?", 30.days.ago).count
                @new_orders = Order.where("created_at > ?", 30.days.ago).count

                #Most demanded product
                hash = OrderProduct.where('created_at > ?', 30.days.ago).group(:product_id).sum(:units)
                most_demanded = hash.sort_by {|_key, value| value}.last
                @most_demanded_product = ""
                if most_demanded
                    @most_demanded_product = Product.find(most_demanded[0]).name 
                end

                @orders_per_postal_code = Order.joins(user: :postal_code).group('postal_codes.code').count.sort_by {|_key, value| value}.to_h
                
                
            end

            private

            def get_users_per_product(products, subscriptions)
               subscriptions.each do |subscription| 
                    #get # of subscription 
                    prod_id = subscription.items.data[0].plan.product
                    product_name = products.find { |prod| prod.id == prod_id }.name
                    if(@users_per_product[product_name])
                        @users_per_product[product_name] += 1 
                    else 
                        @users_per_product[product_name] = 1 
                    end
                end
            end



            def order_params
                params.require(:order)
                      .permit(:id, :date, :created_at, :status, :start_date, :end_date, :search, :sort_by, :order, :delivery_notes,
                              order_products_attributes: [:product_id, :units ]
                    )
            end
            
            def set_orders
                @orders = Order.all
            end
        end
    end
end