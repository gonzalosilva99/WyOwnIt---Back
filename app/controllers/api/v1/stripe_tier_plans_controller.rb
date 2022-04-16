module Api
    module V1
        class StripeTierPlansController < ApplicationController
            
            def get_tiers
                products = Stripe::Price.list({
                    expand: ['data.product']
                })
                
                return render :json => products
            end
        end
    end
end