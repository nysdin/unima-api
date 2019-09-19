class Api::V1::Auth::TokenValidationsController < DeviseTokenAuth::TokenValidationsController

    protected

        def render_validate_token_success
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