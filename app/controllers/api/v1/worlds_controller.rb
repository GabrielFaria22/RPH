module Api
  module V1
    class WorldsController < BaseController
      before_action :authenticate_user!
      before_action :set_world, only: %i[show update destroy]

      def index
        worlds = search_by_name(current_user.admin? ? World.all : World.visible_to(current_user))

        render json: WorldBlueprint.render(with_attached_images(worlds), current_user: current_user)
      end

      def mine
        worlds = search_by_name(current_user.worlds)

        render json: WorldBlueprint.render(with_attached_images(worlds), current_user: current_user)
      end

      def show
        render json: WorldBlueprint.render(@world, current_user: current_user)
      end

      def create
        universe = current_user.universes.find(world_params[:universe_id])
        world = universe.worlds.build(world_params.except(:universe_id))

        if world.save
          render json: WorldBlueprint.render(world, current_user: current_user), status: :created
        else
          render json: { errors: world.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        return forbidden unless owns_world?(@world)

        attributes = world_params
        attributes[:universe] = current_user.universes.find(attributes.delete(:universe_id)) if attributes.key?(:universe_id)

        if @world.update(attributes)
          render json: WorldBlueprint.render(@world, current_user: current_user)
        else
          render json: { errors: @world.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        return forbidden unless owns_world?(@world)

        @world.destroy

        head :no_content
      end

      private

      def set_world
        scope = current_user.admin? ? World.all : World.visible_to(current_user)
        @world = with_attached_images(scope).find(params[:id])
      end

      def world_params
        params.require(:world).permit(:name, :description, :public, :universe_id, :portrait_image, :cover_image, misc_images: [])
      end

      def search_by_name(scope)
        return scope unless params[:q].present?

        scope.where('worlds.name ILIKE ?', "%#{params[:q]}%")
      end

      def with_attached_images(scope)
        scope.with_attached_portrait_image.with_attached_cover_image.with_attached_misc_images
      end

      def owns_world?(world)
        current_user.admin? || world.universe.user_id == current_user.id
      end
    end
  end
end
