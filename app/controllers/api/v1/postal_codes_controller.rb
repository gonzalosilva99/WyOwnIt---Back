module Api
    module V1
        class PostalCodesController < ApplicationController

            def index
                @postal_codes = PostalCode.all
            end

            def create
                if postal_code_params
                    post_code = postal_code_params 
                    post_code["code"] = post_code["code"].upcase
                    @postal_code = PostalCode.create(post_code.merge(place_name: "Not used"))
                    return render :show unless @postal_code.invalid?

                    render json: { errors: @postal_code.errors.messages },
                        status: :unprocessable_entity
                end
            end


            def update
                @postal_code = PostalCode.find params[:id]
                @postal_code.update postal_code_params
                return render :show unless @postal_code.invalid?

                render json: { errors: @postal_code.errors.messages },
                       status: :unprocessable_entity
            end


            def show;
                @postal_code = PostalCode.find(params[:id])
            end

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

            def postal_code_params
                params.require(:postal_code).permit(:id, :place_name,:code)
            end
        end
    end
end
