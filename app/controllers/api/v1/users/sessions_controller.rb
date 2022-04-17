module Api
    module V1
      module Users
        class SessionsController < Devise::SessionsController
          respond_to :json
          private 

        end
      end
    end
  end
  