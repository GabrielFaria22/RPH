module Api
  module V1
    class CharactersController < BaseController
      before_action :authenticate_user!
      before_action :set_character, only: %i[show update destroy]

      def index
        characters = load_characters(current_user.admin? ? Character.all : Character.visible_to(current_user))

        render json: CharacterSummaryBlueprint.render(characters, current_user: current_user)
      end

      def mine
        characters = load_characters(current_user.characters)

        render json: CharacterSummaryBlueprint.render(characters, current_user: current_user)
      end

      def show
        render json: CharacterBlueprint.render(@character, current_user: current_user)
      end

      def create
        attributes = character_params
        universe = current_user.universes.find(attributes.delete(:universe_id))
        character = universe.characters.build(attributes)
        assign_world(character, attributes)
        assign_family(character, attributes)
        assign_faction(character, attributes)

        if character.save
          render json: CharacterBlueprint.render(character, current_user: current_user), status: :created
        else
          render json: { errors: character.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        return forbidden unless owns_character?(@character)

        attributes = character_params
        @character.universe = current_user.universes.find(attributes.delete(:universe_id)) if attributes.key?(:universe_id)
        assign_world(@character, attributes)
        assign_family(@character, attributes)
        assign_faction(@character, attributes)

        if @character.update(attributes)
          render json: CharacterBlueprint.render(@character, current_user: current_user)
        else
          render json: { errors: @character.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        return forbidden unless owns_character?(@character)

        @character.destroy

        head :no_content
      end

      private

      def set_character
        scope = current_user.admin? ? Character.all : Character.visible_to(current_user)

        @character = scope
          .with_attached_portrait_image
          .with_attached_cover_image
          .with_attached_misc_images
          .includes(:relations)
          .find(params[:id])
      end

      def assign_world(character, attributes = character_params)
        return unless attributes.key?(:world_id)

        world_id = attributes.delete(:world_id)
        character.world = world_id.present? ? character.universe.worlds.find(world_id) : nil
      end

      def assign_family(character, attributes = character_params)
        return unless attributes.key?(:family_id)

        family_id = attributes.delete(:family_id)
        character.family = family_id.present? ? character.universe.families.find(family_id) : nil
      end

      def assign_faction(character, attributes = character_params)
        return unless attributes.key?(:faction_id)

        faction_id = attributes.delete(:faction_id)
        character.faction = faction_id.present? ? character.universe.factions.find(faction_id) : nil
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
          :public,
          :universe_id,
          :world_id,
          :family_id,
          :faction_id,
          :portrait_image,
          :cover_image,
          misc_images: []
        )
      end

      def load_characters(scope)
        characters = scope
          .with_attached_portrait_image
          .with_attached_cover_image
          .with_attached_misc_images
          .includes(:relations)
        characters = characters.where('characters.name ILIKE ?', "%#{params[:q]}%") if params[:q].present?
        characters
      end

      def owns_character?(character)
        current_user.admin? || character.universe.user_id == current_user.id
      end
    end
  end
end
