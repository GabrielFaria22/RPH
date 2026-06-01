module Api
  module V1
    class LocationsController < BaseController
      before_action :authenticate_user!
      before_action :set_location, only: %i[show update destroy]

      def index
        locations = load_locations(current_user.admin? ? Location.all : Location.visible_to(current_user))

        render json: LocationBlueprint.render(locations, current_user: current_user)
      end

      def mine
        locations = load_locations(Location.owned_by(current_user))

        render json: LocationBlueprint.render(locations, current_user: current_user)
      end

      def show
        render json: LocationBlueprint.render(@location, current_user: current_user)
      end

      def create
        location = Location.new
        assign_location_attributes(location, location_params)

        if location.save
          render json: LocationBlueprint.render(location, current_user: current_user), status: :created
        else
          render json: { errors: location.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        return forbidden unless owns_location?(@location)

        assign_location_attributes(@location, location_params)

        if @location.save
          render json: LocationBlueprint.render(@location, current_user: current_user)
        else
          render json: { errors: @location.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        return forbidden unless owns_location?(@location)

        @location.destroy

        head :no_content
      end

      private

      def set_location
        scope = current_user.admin? ? Location.all : Location.visible_to(current_user)
        @location = with_attached_images(scope).includes(:child_locations, :universe, world: :universe).find(params[:id])
      end

      def location_params
        params.require(:location).permit(
          :name,
          :location_type,
          :brief_description,
          :full_description,
          :public,
          :universe_id,
          :world_id,
          :parent_location_id,
          :portrait_image,
          :portrait_image_description,
          :cover_image,
          :cover_image_description,
          :banner_image,
          :banner_image_description,
          :crest_image,
          :crest_image_description,
          :misc_images_description,
          misc_images: []
        )
      end

      def assign_location_attributes(location, attributes)
        location.assign_attributes(attributes.except(:universe_id, :world_id, :parent_location_id))
        assign_universe(location, attributes)
        assign_world(location, attributes)
        assign_parent_location(location, attributes)
      end

      def assign_universe(location, attributes)
        return unless attributes.key?(:universe_id)

        universe_id = attributes[:universe_id]
        location.universe = universe_id.present? ? current_user.universes.find(universe_id) : nil
      end

      def assign_world(location, attributes)
        return unless attributes.key?(:world_id)

        world_id = attributes[:world_id]
        location.world = world_id.present? ? current_user.worlds.find(world_id) : nil
      end

      def assign_parent_location(location, attributes)
        return unless attributes.key?(:parent_location_id)

        parent_location_id = attributes[:parent_location_id]
        location.parent_location = parent_location_id.present? ? Location.owned_by(current_user).find(parent_location_id) : nil
      end

      def load_locations(scope)
        locations = with_attached_images(scope).includes(:child_locations, :universe, world: :universe)
        search_records(locations)
      end

      def with_attached_images(scope)
        scope
          .with_attached_portrait_image
          .with_attached_cover_image
          .with_attached_banner_image
          .with_attached_crest_image
          .with_attached_misc_images
      end

      def owns_location?(location)
        current_user.admin? || location.universe_context&.user_id == current_user.id
      end
    end
  end
end
