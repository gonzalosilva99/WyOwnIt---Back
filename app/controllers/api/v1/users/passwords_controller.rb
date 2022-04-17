module Api
    module V1
      module Users
        class PasswordsController < Devise::PasswordsController
          include RackSessionFix  
          respond_to :json
        end
      end
    end
  end
  