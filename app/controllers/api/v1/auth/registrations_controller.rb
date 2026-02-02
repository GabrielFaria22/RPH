module Api
  module V1
    module Auth
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json

        private

        def sign_up_params
          params.require(:user).permit(:email, :password, :password_confirmation)
        end

        def respond_with(resource, _opts = {})
          if resource.persisted?
            render json: {
              status: { code: 200, message: 'Signed up successfully.' },
              data: UserBlueprint.render_as_hash(resource)
            }, status: :ok
          else
            render json: {
              status: { code: 422, message: "User couldn't be created." },
              errors: resource.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        def sign_up(_resource_name, _resource)
        end
      end
    end
  end
end