module Api
  module V1
    class FactionRelationsController < BaseController
      before_action :authenticate_user!
      before_action :set_faction_relation, only: %i[show update destroy]

      def index
        faction_relations = FactionRelation.joins(faction: :universe)
        faction_relations = faction_relations.where(universes: { user_id: current_user.id }) unless current_user.admin?

        render json: FactionRelationBlueprint.render(faction_relations)
      end

      def show
        render json: FactionRelationBlueprint.render(@faction_relation)
      end

      def create
        faction_relation = FactionRelation.new(faction_relation_attributes)

        if faction_relation.save
          render json: FactionRelationBlueprint.render(faction_relation), status: :created
        else
          render json: { errors: faction_relation.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @faction_relation.update(faction_relation_attributes)
          render json: FactionRelationBlueprint.render(@faction_relation)
        else
          render json: { errors: @faction_relation.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @faction_relation.destroy

        head :no_content
      end

      private

      def set_faction_relation
        scope = FactionRelation.joins(faction: :universe)
        scope = scope.where(universes: { user_id: current_user.id }) unless current_user.admin?
        @faction_relation = scope.find(params[:id])
      end

      def faction_relation_attributes
        attributes = faction_relation_params
        attributes[:faction] = editable_factions.find(attributes.delete(:faction_id)) if attributes.key?(:faction_id)
        if attributes.key?(:related_faction_id)
          attributes[:related_faction] = editable_factions.find(attributes.delete(:related_faction_id))
        end
        attributes
      end

      def faction_relation_params
        params.require(:faction_relation).permit(:faction_id, :related_faction_id, :relation_type)
      end

      def editable_factions
        current_user.admin? ? Faction.all : current_user.factions
      end
    end
  end
end
