class Api::V1::RelationshipsController < ApplicationController
    before_action :authenticate_api_user!

    def create
        @user = User.find_by(id: params[:followed_id])
        if @user
            head :bad_request and return if current_api_user.following?(@user)
            current_api_user.follow(@user)
            head :ok
        else
            head :not_found
        end
    end
    
    def destroy
        @user = User.find_by(id: params[:id])
        if @user
            head :bad_request and return unless current_api_user.following?(@user)
            current_api_user.unfollow(@user)
            head :ok
        else
            head :not_found
        end
    end
end
