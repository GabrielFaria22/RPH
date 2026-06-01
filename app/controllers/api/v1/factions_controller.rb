module Api
  module V1
    class FactionsController < BaseController
      before_action :authenticate_user!
      before_action :set_faction, only: %i[show update destroy]

      def index
        factions = search_records(current_user.admin? ? Faction.all : Faction.visible_to(current_user))

        render json: FactionBlueprint.render(with_attached_images(factions).includes(:families), current_user: current_user)
      end

      def mine
        factions = search_records(current_user.factions)

        render json: FactionBlueprint.render(with_attached_images(factions).includes(:families), current_user: current_user)
      end

      def show
        render json: FactionBlueprint.render(@faction, current_user: current_user)
      end

      def create
        universe = current_user.universes.find(faction_params[:universe_id])
        family_ids = faction_params[:family_ids]
        return render_at_least_one_family_required if family_ids.blank?

        faction = universe.factions.build(faction_attributes(faction_params.except(:universe_id, :family_ids), universe))
        families = universe.families.where(id: family_ids)

        if families.size != family_ids.size
          return render json: { errors: ['Families must belong to the same universe'] }, status: :unprocessable_entity
        end

        Faction.transaction do
          faction.save!
          families.update_all(faction_id: faction.id, updated_at: Time.current)
        end

        render json: FactionBlueprint.render(faction.reload, current_user: current_user), status: :created
      rescue ActiveRecord::RecordInvalid => error
        render json: { errors: error.record.errors.full_messages }, status: :unprocessable_entity
      end

      def update
        return forbidden unless owns_faction?(@faction)

        attributes = faction_params
        universe = attributes.key?(:universe_id) ? current_user.universes.find(attributes.delete(:universe_id)) : @faction.universe
        family_ids = attributes.delete(:family_ids)
        @faction.universe = universe

        if family_ids && family_ids.blank?
          return render_at_least_one_family_required
        end

        families = family_ids ? universe.families.where(id: family_ids) : nil
        if family_ids && families.size != family_ids.size
          return render json: { errors: ['Families must belong to the same universe'] }, status: :unprocessable_entity
        end

        Faction.transaction do
          @faction.update!(faction_attributes(attributes, universe))
          replace_families(families) if families
        end

        render json: FactionBlueprint.render(@faction.reload, current_user: current_user)
      rescue ActiveRecord::RecordInvalid => error
        render json: { errors: error.record.errors.full_messages }, status: :unprocessable_entity
      end

      def destroy
        return forbidden unless owns_faction?(@faction)

        @faction.destroy

        head :no_content
      end

      private

      def set_faction
        scope = current_user.admin? ? Faction.all : Faction.visible_to(current_user)
        @faction = with_attached_images(scope).includes(:families).find(params[:id])
      end

      def faction_params
        params.require(:faction).permit(
          :name,
          :description,
          :public,
          :universe_id,
          :leader_character_id,
          :portrait_image,
          :portrait_image_description,
          :cover_image,
          :cover_image_description,
          :banner_image,
          :banner_image_description,
          :crest_image,
          :crest_image_description,
          :misc_images_description,
          family_ids: [],
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

      def faction_attributes(attributes, universe)
        if attributes.key?(:leader_character_id)
          attributes[:leader_character] = universe.characters.find(attributes.delete(:leader_character_id))
        end

        attributes
      end

      def replace_families(families)
        @faction.families.where.not(id: families.select(:id)).update_all(faction_id: nil, updated_at: Time.current)
        families.update_all(faction_id: @faction.id, updated_at: Time.current)
      end

      def render_at_least_one_family_required
        render json: { errors: ['Faction must have at least one family'] }, status: :unprocessable_entity
      end

      def owns_faction?(faction)
        current_user.admin? || faction.universe.user_id == current_user.id
      end
    end
  end
end
