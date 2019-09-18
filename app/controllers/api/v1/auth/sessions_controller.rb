class Api::V1::Auth::SessionsController < DeviseTokenAuth::SessionsController

    protected

        def render_create_success
            render json: {
                data: @resource.as_json(except: %i[tokens created_at updated_at],
                include: {
                    notifications: {
                        include: {
                            sender: { only: [:id, :name] },
                            product: { only: [:id, :name, :images] }
                        }
                    }
                })
            }
        end
end