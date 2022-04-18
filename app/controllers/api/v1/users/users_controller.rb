module Api
    module V1
        module Users
            class UsersController < ApplicationController
                def my_user
                    if current_customer
                        render json: current_customer.as_json
                    elsif current_admin 
                        render json: current_admin.as_json
                    else
                        render json: { error: "Not logged in or token expired" }, status: :unauthorized
                    end
                end
            end
        end
    end
end