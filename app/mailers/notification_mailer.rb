class NotificationMailer < ApplicationMailer
    def new_notification_email
      @message = params[:message]
      @addressee = params[:addressee]
  
      if(!@message || !@addressee )
        throw "Error, addressee and message needed"
      end
      mail(to: @addressee, subject: 'New notification - WyOwnIt')
    end
end