class ApplicationController < ActionController::API
    include CanCan::ControllerAdditions
    rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
    respond_to :json
    helper_method :current_user

    
    rescue_from StandardError do |error|
      render json: { error: error.message }, status: :internal_server_error
    end
  
    rescue_from CanCan::AccessDenied do |exception|
      render json: { errors: exception.message }, status: :forbidden
    end
    private

    def current_ability
      unless @current_ability.present?
        @current_ability = Ability.new(current_user)      
      end
  
      @current_ability
    end

    def handle_not_found(error)
        render json: { error: error.message }, status: :not_found
    end
    
    def handle_error(error)
        render json: { error: error.message }, status: error.status
    end

    def authenticate_user
        authenticate_user!
    end

    def current_user
        @current_user ||= super || User.find(@current_user_id)
    end
end
