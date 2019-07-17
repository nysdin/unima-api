class ApplicationController < ActionController::API
        include Pundit
        include DeviseTokenAuth::Concerns::SetUserByToken

        def pundit_user 
                current_api_user 
        end
end
