module Api
    module V1
        class StripeTierPlansController < ApplicationController
            before_action :authenticate_user, only: %i[get_active_subscriptions]
            
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
        end
    end
end