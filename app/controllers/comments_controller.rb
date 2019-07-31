class CommentsController < ApplicationController
    before_action :authenticate_api_user!
    
    def create
    end

    def destroy
    end

    private

        def comment_params
            params.permit(:contents)
        end
end
