module Api
  module V1
    module Auth
      class SessionsController < BaseController
        before_action :authenticate_user!, only: :destroy

        def create
          user = User.find_by(email: sign_in_params[:email])

          if user && user.valid_password?(sign_in_params[:password])
            # Generate JWT token by signing in with Devise
            token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
            
            response.headers['Authorization'] = "Bearer #{token}"
            
            render json: {
              status: { code: 200, message: 'Logged in successfully.' },
              data: UserBlueprint.render_as_hash(user),
              token: token
            }, status: :ok
          else
            render json: {
              status: { code: 401, message: 'Invalid email or password.' }
            }, status: :unauthorized
          end
        end

        def destroy
          render json: {
            status: { code: 200, message: 'Logged out successfully.' }
          }, status: :ok
        end

        private

        def sign_in_params
          params.require(:user).permit(:email, :password)
        end
      end
    end
  end
end
