module Api
  module V1
    class UniversesController < BaseController
      before_action :authenticate_user!
      before_action :set_universe, only: %i[show update destroy]

      def index
        universes = search_records(current_user.admin? ? Universe.all : Universe.visible_to(current_user))

        render json: UniverseBlueprint.render(with_attached_images(universes), current_user: current_user)
      end

      def mine
        universes = search_records(current_user.universes)

        render json: UniverseBlueprint.render(with_attached_images(universes), current_user: current_user)
      end

      def show
        render json: UniverseBlueprint.render(@universe, current_user: current_user)
      end

      def create
        universe = current_user.universes.build(universe_params)

        if universe.save
          render json: UniverseBlueprint.render(universe, current_user: current_user), status: :created
        else
          render json: { errors: universe.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        return forbidden unless owns_universe?(@universe)

        if @universe.update(universe_params)
          render json: UniverseBlueprint.render(@universe, current_user: current_user)
        else
          render json: { errors: @universe.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        return forbidden unless owns_universe?(@universe)

        @universe.destroy

        head :no_content
      end

      private

      def set_universe
        scope = current_user.admin? ? Universe.all : Universe.visible_to(current_user)
        @universe = with_attached_images(scope).find(params[:id])
      end

      def universe_params
        params.require(:universe).permit(
          :name,
          :genre,
          :description,
          :public,
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

      def with_attached_images(scope)
        scope
          .with_attached_portrait_image
          .with_attached_cover_image
          .with_attached_banner_image
          .with_attached_crest_image
          .with_attached_misc_images
      end

      def owns_universe?(universe)
        current_user.admin? || universe.user_id == current_user.id
      end
    end
  end
end
