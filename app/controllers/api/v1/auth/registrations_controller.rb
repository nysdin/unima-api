class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController

    def create
        build_resource

        address_kanji = params[:address_kanji]
        address_kana = params[:address_kana]
        dob = params[:dob]

        individual = {
            address_kanji: {
                postal_code: address_kanji[:postal_code],
                state: address_kanji[:state],
                city: address_kanji[:city],
                town: address_kanji[:town],
                line1: address_kanji[:line1],
                line2: address_kanji[:line2]
            },
            address_kana: {
                postal_code: address_kana[:postal_code],
                state: address_kana[:state],
                city: address_kana[:city],
                town: address_kana[:town],
                line1: address_kana[:line1],
                line2: address_kana[:line2]
            },
            dob: { year: dob[:year], month: dob[:month], day: dob[:day] },
            first_name_kana: params[:first_name_kana], last_name_kana: params[:last_name_kana],
            first_name_kanji: params[:first_name_kanji], last_name_kanji: params[:last_name_kanji],
            gender: params[:gender], phone: params[:phone]
        }

        begin 
            acct = Stripe::Account.create({
                country: 'JP',
                type: 'custom',
                business_type: 'individual',
                email: @resource.email,
                individual: individual,
                tos_acceptance: {
                    date: Time.now.to_i,
                    ip: request.remote_ip,
                }
            })
            @resource.stripe_account_id = acct.id
        rescue => e
            render json: { errors: ["本人情報の入力に誤りがあります."] }, status: :bad_request and return
        end

        unless @resource.present?
            raise DeviseTokenAuth::Errors::NoResourceDefinedError,
                    "#{self.class.name} #build_resource does not define @resource,"\
                    ' execution stopped.'
        end

        # give redirect value from params priority
        @redirect_url = params.fetch(
            :confirm_success_url,
            DeviseTokenAuth.default_confirm_success_url
        )

        # success redirect url is required
        if confirmable_enabled? && !@redirect_url
            return render_create_error_missing_confirm_success_url
        end

        # if whitelist is set, validate redirect_url against whitelist
        return render_create_error_redirect_url_not_allowed if blacklisted_redirect_url?

        # override email confirmation, must be sent manually from ctrl
        resource_class.set_callback('create', :after, :send_on_create_confirmation_instructions)
        resource_class.skip_callback('create', :after, :send_on_create_confirmation_instructions)

        if @resource.respond_to? :skip_confirmation_notification!
            # Fix duplicate e-mails by disabling Devise confirmation e-mail
            @resource.skip_confirmation_notification!
        end

        if @resource.save
            yield @resource if block_given?
    
            unless @resource.confirmed?
                # user will require email authentication
                @resource.send_confirmation_instructions({
                client_config: params[:config_name],
                redirect_url: @redirect_url
                })
            end

            if active_for_authentication?
                # email auth has been bypassed, authenticate user
                @client_id, @token = @resource.create_token
                @resource.save!
                update_auth_header
            end

            #render_create_success
            head :created
        else
            clean_up_passwords @resource
            #render_create_error
            render json: { errors: @resource.errors.full_messages }, status: :unprocessable_entity
        end
    end
end