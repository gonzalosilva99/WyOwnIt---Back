module Api
    module V1
        class PostalCodesController < ApplicationController

            def validate_postal_code
                if params[:postal_code]
                    postalcode = PostalCode.where(code: params[:postal_code])
                    if postalcode
                        render json: postalcode.as_json
                    else 
                        render json: { error: "Postal code not valid" }, status: :internal_server_error
                    end
                end
            end

            private
            
            def product_params
                params.require(:postal_code)
            end
        end
    end
end