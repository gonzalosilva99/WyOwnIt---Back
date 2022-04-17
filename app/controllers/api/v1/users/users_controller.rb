module Api
    module V1
        module Users
            class UsersController < ApplicationController
                before_action :authenticate_user
                load_and_authorize_resource

                def my_user
                    render json: current_user.as_json
                end

            end
        end
    end
end