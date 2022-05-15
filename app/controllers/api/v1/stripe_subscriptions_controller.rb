module Api
    module V1
        class StripeSubscriptionsController < ApplicationController
            before_action :authenticate_user, only: %i[get_active_subscription]
            
            def get_tiers
                products = Stripe::Price.list({
                    expand: ['data.product']
                })
                
                return render :json => products
            end

            def get_active_subscriptions
                user = @current_user
                customer = Stripe::Customer.list({email: 'santiago@gmail.com' })
                if(customer)
                    subscriptions = Stripe::Subscription.list({customer: customer.id})
                    return render :json => subscriptions
                end

            end 
        end
    end
end