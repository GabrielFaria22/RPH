module Api
  module V1
    class FamiliesController < BaseController
      before_action :authenticate_user!
      before_action :set_family, only: %i[show update destroy]

      def index
        families = search_by_name(current_user.admin? ? Family.all : Family.visible_to(current_user))

        render json: FamilyBlueprint.render(families.includes(:family_tree), current_user: current_user)
      end

      def mine
        families = search_by_name(current_user.families)

        render json: FamilyBlueprint.render(families.includes(:family_tree), current_user: current_user)
      end

      def show
        render json: FamilyBlueprint.render(@family, current_user: current_user)
      end

      def create
        universe = current_user.universes.find(family_params[:universe_id])
        family = universe.families.build(family_attributes(family_params.except(:universe_id), universe))

        if family.save
          render json: FamilyBlueprint.render(family, current_user: current_user), status: :created
        else
          render json: { errors: family.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        return forbidden unless owns_family?(@family)

        attributes = family_params
        universe = attributes.key?(:universe_id) ? current_user.universes.find(attributes.delete(:universe_id)) : @family.universe
        @family.universe = universe

        next_attributes = family_attributes(attributes, universe)
        return render_last_family_required if removes_last_family_from_faction?(next_attributes)

        if @family.update(next_attributes)
          render json: FamilyBlueprint.render(@family, current_user: current_user)
        else
          render json: { errors: @family.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        return forbidden unless owns_family?(@family)

        return render_last_family_required if last_family_in_faction?

        @family.destroy

        head :no_content
      end

      private

      def set_family
        scope = current_user.admin? ? Family.all : Family.visible_to(current_user)
        @family = scope.includes(:family_tree).find(params[:id])
      end

      def family_params
        params.require(:family).permit(:name, :description, :public, :universe_id, :leader_character_id, :faction_id)
      end

      def family_attributes(attributes, universe)
        if attributes.key?(:leader_character_id)
          attributes[:leader_character] = universe.characters.find(attributes.delete(:leader_character_id))
        end

        if attributes.key?(:faction_id)
          faction_id = attributes.delete(:faction_id)
          attributes[:faction] = faction_id.present? ? universe.factions.find(faction_id) : nil
        end

        attributes
      end

      def removes_last_family_from_faction?(attributes)
        return false unless attributes.key?(:faction)
        return false if @family.faction.blank? || attributes[:faction] == @family.faction

        @family.faction.families.where.not(id: @family.id).none?
      end

      def last_family_in_faction?
        @family.faction.present? && @family.faction.families.where.not(id: @family.id).none?
      end

      def render_last_family_required
        render json: { errors: ['Faction must have at least one family'] }, status: :unprocessable_entity
      end

      def search_by_name(scope)
        return scope unless params[:q].present?

        scope.where('families.name ILIKE ?', "%#{params[:q]}%")
      end

      def owns_family?(family)
        current_user.admin? || family.universe.user_id == current_user.id
      end
    end
  end
end
