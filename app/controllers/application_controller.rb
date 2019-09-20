class ApplicationController < ActionController::API
    before_action :configure_permitted_parameters, if: :devise_controller?
    include Pundit
    include DeviseTokenAuth::Concerns::SetUserByToken
    include Pagy::Backend

    def pundit_user 
            current_api_user 
    end
    
    protected

        def configure_permitted_parameters
            devise_parameter_sanitizer.permit(:sign_up, keys: [:name, 
                                        :email, :avatar, :password, :password_confirmation])
            devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :avatar])
        end
end
