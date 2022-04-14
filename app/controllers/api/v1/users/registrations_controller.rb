module Api
    module V1
      module Users
        class RegistrationsController < Devise::RegistrationsController
          include RackSessionFix  
          before_action :sign_up_params
            after_action -> { request.session_options[:skip] = true }
            respond_to :json

            private 
            
            def sign_up_params
                params.require(:user)
                    .permit(:name,:email,:password,:password_confirmation, :lastname, :address, :phone, :unitnumber,:type
                    )
        end
        end
      end
    end
  end