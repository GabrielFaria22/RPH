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

      def search_records(scope, default_attribute: :name)
        query = ransack_query(default_attribute)
        return scope if query.blank?

        scope.ransack(query).result
      end

      def ransack_query(default_attribute)
        case params[:q]
        when String
          return if params[:q].blank?

          { "#{default_attribute}_cont" => params[:q] }
        when ActionController::Parameters
          params[:q].to_unsafe_h
        when Hash
          params[:q]
        end
      end
    end
  end
end
