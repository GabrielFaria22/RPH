module Api
  module V1
    class CharactersController < BaseController
      before_action :authenticate_user!
      before_action :set_character, only: %i[show update destroy]

      def index
        characters = current_user.characters
          .with_attached_portrait_image
          .with_attached_cover_image
          .includes(:relations)

        render json: CharacterBlueprint.render(characters)
      end

      def show
        render json: CharacterBlueprint.render(@character)
      end

      def create
        attributes = character_params
        universe = current_user.universes.find(attributes.delete(:universe_id))
        character = universe.characters.build(attributes)
        assign_world(character, attributes)

        if character.save
          render json: CharacterBlueprint.render(character), status: :created
        else
          render json: { errors: character.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        attributes = character_params
        @character.universe = current_user.universes.find(attributes.delete(:universe_id)) if attributes.key?(:universe_id)
        assign_world(@character, attributes)

        if @character.update(attributes)
          render json: CharacterBlueprint.render(@character)
        else
          render json: { errors: @character.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @character.destroy

        head :no_content
      end

      private

      def set_character
        @character = current_user.characters
          .with_attached_portrait_image
          .with_attached_cover_image
          .includes(:relations)
          .find(params[:id])
      end

      def assign_world(character, attributes = character_params)
        return unless attributes.key?(:world_id)

        world_id = attributes.delete(:world_id)
        character.world = world_id.present? ? current_user.worlds.find(world_id) : nil
      end

      def character_params
        params.require(:character).permit(
          :name,
          :full_name,
          :nickname,
          :age,
          :appearance,
          :occupation,
          :description,
          :story,
          :universe_id,
          :world_id,
          :portrait_image,
          :cover_image
        )
      end
    end
  end
end
