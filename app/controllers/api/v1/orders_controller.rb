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
                begin 
                    if is_order_valid
                        @order = Order.create!(order_params.merge(user: @current_user, status: "pending"))
                        message = 'Your new order has been created, check "My orders" to see it.'
                        Notification.create(title: 'Order created', message: message, user: @order.user, seen: false)
                        NotificationMailer.with(message: message, addressee: @current_user.email).new_notification_email.deliver_now
                        admins = Admin.all
                        admins.each do |admin| 
                            NotificationMailer.with(message: "A new order was created, please check it.", addressee: admin.email).new_notification_email.deliver_now
                        end
                        @order.save
                    else 
                        return render json: { result: false }
                    end
                    
                rescue StandardError => e
                    reason = e.message
                    return render json: {result: false, reason: reason}
                end 
                
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

            def validate_order 
                begin
                    if is_order_valid
                        return render json: { result: true }
                    else 
                        return render json: { result: false }
                    end
                rescue StandardError => e
                    reason = e.message
                    return render json: {result: false, reason: reason}
                end    
            end 

            private


            def is_order_valid 
                user = @current_user
                order = Order.new(order_params.merge(user: @current_user, status: "pending"))
                if(order.valid?)
                    #get subscription of the user 
                    customer = Stripe::Customer.list({email: user.email})
                    if(customer)
                        subscriptions = []
                        if customer.data.count > 0 
                            subscriptions = Stripe::Subscription.list({customer: customer.data[0].id, status: 'active'})
                        end
                        if subscriptions 
                            subscription = subscriptions.data[0]
                            if !subscription
                                raise StandardError.new "You don't have any subscription."
                            end 
                            max_orders_allowed = subscription.items.data[0].plan.metadata.max_orders_per_month.to_i
                            max_days_allowed = subscription.items.data[0].plan.metadata.max_days_per_order.to_i
                            max_products_per_order = subscription.items.data[0].plan.metadata.max_products_per_order.to_i
                            subscription_tag = subscription.items.data[0].plan.metadata.tag
                            
                            starter_date = Time.at(subscription.current_period_start).to_datetime
                            order_of_this_period = user.orders.where("created_at > ?", starter_date).count 
                            end_date = order.end_date.to_date
                            start_date = order.start_date.to_date
                            days_ordered = (end_date - start_date).to_i
                            products_of_order = 0
                            order.order_products.each do |ord_prod|
                                products_of_order += ord_prod.units
                                if(!check_product_stock(ord_prod, start_date, end_date))
                                    product = Product.find(ord_prod.product_id)
                                    raise StandardError.new "Sorry, we don't have stock for " + product.name + " those days."
                                end
                            end
                            
                            if(!validate_products_tag(order, subscription_tag))
                                raise StandardError.new "One of the selected products is not allowed for your subscription."
                            elsif(order_of_this_period >= max_orders_allowed )
                                raise StandardError.new "Sorry, you have exceeded your monthly order limit, please upgrade to continue."
                            elsif(days_ordered > max_days_allowed)
                                raise StandardError.new "Sorry, you have exceeded your rental day booking limit. Please reduce to continue."
                            elsif(products_of_order > max_products_per_order)
                                raise StandardError.new "Sorry, you have exceeded your products per order limit. Please reduce your cart to continue."
                            else 
                                return true
                            end
                        else
                            raise StandardError.new "You don't have any active subscription"
                        end 
                    else
                        raise StandardError.new "Error with the logged user"
                    end 
                else
                    raise StandardError.new "Order not valid."
                end 
                return false 
            end

            def check_product_stock(order_product, start_date, end_date)
                if(order_product)
                    product = Product.find(order_product.product_id)
                    total_stock = product.stock
                    collision_orders = OrderProduct.where(product_id: product.id).joins(:order).where("(end_date >= ? OR start_date >= ?)",start_date - 2.days, end_date + 2.days)
                    if collision_orders 
                        consumed_stock = 0
                        collision_orders.each do |ord_prod|
                            consumed_stock += ord_prod.units
                        end  
                        if consumed_stock >= total_stock + order_product.units 
                            return false 
                        end 
                    end
                end
                true
            end

            def validate_products_tag(order, tag)
                valid_tags = []
                valid = true  
                case tag 
                when 'pro'
                    valid_tags.push('starter','intermediate','deluxe','pro')
                when 'deluxe'
                    valid_tags.push('starter','intermediate','deluxe')
                when 'intermediate'
                    valid_tags.push('starter','intermediate')
                when 'starter'
                    valid_tags.push('starter')
                else 
                end

                order.order_products.each do |ord_prod|
                    product = Product.find(ord_prod.product_id)
                    tag = product.tag 
                    valid = false if(!valid_tags.include? tag)
                end
                return valid 
            end

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