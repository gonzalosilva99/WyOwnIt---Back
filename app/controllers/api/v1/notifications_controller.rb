module Api
    module V1
        class NotificationsController < ApplicationController
            before_action :authenticate_user

            def index
                page = params[:page] ? params[:page] : 1
                limit = params[:limit] ? params[:limit] : 10
                user = current_user
                @notifications = {}
                
                if(user)
                    @notifications = user.notifications.paginate(:page => page, :per_page => limit).order('id DESC')
                end
                @notifications
            end

            def show;
                @notification = Notification.find(params[:id])
            end

            def update 
                @notification = Notification.find params[:id]
                @notification.update notification_params
                return render :show unless @notification.invalid?

                render json: { errors: @notification.errors.messages },
                       status: :unprocessable_entity
            end


            def has_unseen_notifications 
                user = current_user
                has_unseen = user.notifications.where(seen: [false, nil]).count > 0 
                return render json: { result: has_unseen.to_s }
            end 

            private
            def notification_params
                params.require(:notification)
                      .permit(:id, :message, :seen)
            end
            
            def set_notifications
                @notifications = Notification.all
            end
        end
    end
end