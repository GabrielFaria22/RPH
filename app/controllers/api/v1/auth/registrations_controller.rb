module Api
  module V1
    module Auth
      class RegistrationsController < BaseController
        def create
          user = User.new(sign_up_params)

          if user.save
            render json: {
              status: { code: 200, message: 'Signed up successfully.' },
              data: UserBlueprint.render_as_hash(user)
            }, status: :ok
          else
            render json: {
              status: { code: 422, message: "User couldn't be created." },
              errors: user.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        private

        def sign_up_params
          params.require(:user).permit(:email, :password, :password_confirmation)
        end
      end
    end
  end
end
