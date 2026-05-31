module Api
  module V1
    class BaseController < ApplicationController
      respond_to :json

      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

      private

      def record_not_found
        render json: { errors: ['Record not found'] }, status: :not_found
      end

      def forbidden
        render json: { errors: ['Forbidden'] }, status: :forbidden
      end
    end
  end
end
