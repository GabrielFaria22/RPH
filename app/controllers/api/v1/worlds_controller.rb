module Api
  module V1
    class WorldsController < BaseController
      before_action :authenticate_user!
      before_action :set_world, only: %i[show update destroy]

      def index
        render json: WorldBlueprint.render(current_user.worlds)
      end

      def show
        render json: WorldBlueprint.render(@world)
      end

      def create
        universe = current_user.universes.find(world_params[:universe_id])
        world = universe.worlds.build(world_params.except(:universe_id))

        if world.save
          render json: WorldBlueprint.render(world), status: :created
        else
          render json: { errors: world.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        attributes = world_params
        attributes[:universe] = current_user.universes.find(attributes.delete(:universe_id)) if attributes.key?(:universe_id)

        if @world.update(attributes)
          render json: WorldBlueprint.render(@world)
        else
          render json: { errors: @world.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @world.destroy

        head :no_content
      end

      private

      def set_world
        @world = current_user.worlds.find(params[:id])
      end

      def world_params
        params.require(:world).permit(:name, :description, :universe_id)
      end
    end
  end
end
