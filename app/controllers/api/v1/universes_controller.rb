module Api
  module V1
    class UniversesController < BaseController
      before_action :authenticate_user!
      before_action :set_universe, only: %i[show update destroy]

      def index
        render json: UniverseBlueprint.render(current_user.universes)
      end

      def show
        render json: UniverseBlueprint.render(@universe)
      end

      def create
        universe = current_user.universes.build(universe_params)

        if universe.save
          render json: UniverseBlueprint.render(universe), status: :created
        else
          render json: { errors: universe.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @universe.update(universe_params)
          render json: UniverseBlueprint.render(@universe)
        else
          render json: { errors: @universe.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @universe.destroy

        head :no_content
      end

      private

      def set_universe
        @universe = current_user.universes.find(params[:id])
      end

      def universe_params
        params.require(:universe).permit(:name, :description)
      end
    end
  end
end
