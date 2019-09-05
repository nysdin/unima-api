class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController

    def create
        build_resource

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
        callback_name = defined?(ActiveRecord) && resource_class < ActiveRecord::Base ? :commit : :create
        resource_class.set_callback(callback_name, :after, :send_on_create_confirmation_instructions)
        resource_class.skip_callback(callback_name, :after, :send_on_create_confirmation_instructions)

        if @resource.respond_to? :skip_confirmation_notification!
            # Fix duplicate e-mails by disabling Devise confirmation e-mail
            @resource.skip_confirmation_notification!
        end

        # Stripe.api_key = 'sk_test_l6d9CT8rhVwWIVgJQ4yTSxwu003ESqmv05'

        # address_kanji = params[:address_kanji]
        # address_kana = params[:address_kana]
        # dob = params[:dob]

        # individual = {
        #     address_kanji: {
        #         postal_code: address_kanji[:postal_code],
        #         state: address_kanji[:state],
        #         city: address_kanji[:city],
        #         town: address_kanji[:town],
        #         line1: address_kanji[:line1],
        #         line2: address_kanji[:line2]
        #     },
        #     address_kana: {
        #         postal_code: address_kana[:postal_code],
        #         state: address_kana[:state],
        #         city: address_kana[:city],
        #         town: address_kana[:town],
        #         line1: address_kana[:line1],
        #         line2: address_kana[:line2]
        #     },
        #     dob: { year: dob[:year], month: dob[:month], day: dob[:day] },
        #     first_name_kana: params[:first_name_kana], last_name_kana: params[:last_name_kana],
        #     first_name_kanji: params[:first_name_kanji], last_name_kanji: params[:last_name_kanji],
        #     gender: params[:gender], phone: params[:phone]
        # }

        # begin 
        #     acct = Stripe::Account.create({
        #         country: 'JP',
        #         type: 'custom',
        #         business_type: 'individual',
        #         email: @resource.email,
        #         individual: individual
        #     })
        #     resource.stripe_account_id = acct.id
        # rescue => e
        #     head :bad_request and return
        # end

        # if params[:stripe_cregit_token].present?
        #     begin
        #         customer = Stripe::Customer.create({
        #             source: params[:stripe_cregit_token],
        #             email: resource.email
        #         })
        #         resource.stripe_customer_id = customer.id
        #     rescue => e
        #         head :bad_request and return
        #     end
        # end

        # if params[:stripe_bank_token].present?
        #     begin 
        #         Stripe::Account.update(acct.id, {external_account: params[:stripe_bank_token]})
        #     rescue => e
        #         head :bad_request and return
        #     end
        # end

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
                @token = @resource.create_token
                @resource.save!
                
                binding.pry
                
                update_auth_header
                
                binding.pry
                
            end

            render_create_success
        else
            clean_up_passwords @resource
            render_create_error
        end
    end
end