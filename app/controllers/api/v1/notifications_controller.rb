class Api::V1::NotificationsController < ApplicationController
    before_action :authenticate_api_user!

    def check
        notifications = current_api_user.notifications.where(id: params[:ids])
        if notifications
            notifications.each do |notification|
                notification.update_attributes(checked: true)
            end
            head :ok
        else
            haed :not_found
        end
    end
end
