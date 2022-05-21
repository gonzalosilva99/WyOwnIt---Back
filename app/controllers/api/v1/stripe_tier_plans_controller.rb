module Api
    module V1
        class StripeTierPlansController < ApplicationController
            before_action :authenticate_user, except: [:get_tiers]
            
            def get_tiers
                products = Stripe::Price.list({
                    expand: ['data.product']
                })
                
                return render :json => products
            end

            def get_active_subscriptions
                user = current_user
                customer = Stripe::Customer.list({email: user.email})
                if(customer)
                    subscriptions = []
                    if customer.data.count > 0 
                        subscriptions = Stripe::Subscription.list({customer: customer.data[0].id, status: 'active'})
                    end
                    return render :json => subscriptions
                end
            end 

            def upgrade_subscription
                new_price = params[:new_price]
                if(!new_price)
                    render json: { error: "Error, new price needed" }
                else
                    user = current_user
                    customer = Stripe::Customer.list({email: user.email})
                    if(customer)
                        subscriptions = []
                        if customer.data.count > 0 
                            subscriptions = Stripe::Subscription.list({customer: customer.data[0].id, status: 'active'})
                        else 
                            render json: { error: "Error, there is no logged customer" }
                        end
    
                        if(subscriptions.count > 0)
                            subscription = subscriptions.data[0]
                            if subscription
                                Stripe::Subscription.update(
                                    subscription.id,
                                    {'items[0][id]': subscription.items.data[0].id, 'items[0][price]': new_price, 'proration_behavior': 'create_prorations'},
                                )
                                render json: { message: "The subscription have been successfully upgraded." }
                            else
                                render json: { error: "Error with the subscription." }
                            end  
                        else
                            render json: { error: "Error, the customer does not have any active subscription" }
                        end
                    else 
                        render json: { error: "Error, there is no logged customer" }
                    end
                end 
            end 

            def cancel_subscription 
                user = current_user
                customer = Stripe::Customer.list({email: user.email})
                if(customer)
                    subscriptions = []
                    if customer.data.count > 0 
                        subscriptions = Stripe::Subscription.list({customer: customer.data[0].id, status: 'active'})
                    end
                    if(subscriptions)
                        subscription = subscriptions.data[0]
                        if subscription 
                            Stripe::Subscription.delete(
                                subscription.id
                            )
                            render json: { message: "The subscription have been successfully cancelled." }
                        else
                            render json: { error: "Error with the subscription." }
                        end
                    else
                        render json: { error: "Error, the customer does not have any active subscription" }
                    end
                else
                    render json: { error: "Error, there is no logged customer" }
                end
            end
        end 
    end
end