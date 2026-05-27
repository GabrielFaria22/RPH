class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers

  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def authenticate_user!
    return if current_user

    render json: { errors: ['Unauthorized'] }, status: :unauthorized
  end

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = request.env['warden'].authenticate(scope: :user) || jwt_user
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email])
  end

  def jwt_user
    token = request.headers['Authorization'].to_s[/\ABearer (.+)\z/, 1]
    return if token.blank?

    payload = Warden::JWTAuth::TokenDecoder.new.call(token)
    return unless payload['scp'] == 'user'

    User.find_by(id: payload['sub'], jti: payload['jti'])
  rescue JWT::DecodeError, Warden::JWTAuth::Errors::Error
    nil
  end
end
