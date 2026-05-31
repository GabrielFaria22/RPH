module Api
  module V1
    class FamilyRelationsController < BaseController
      before_action :authenticate_user!
      before_action :set_family_relation, only: %i[show update destroy]

      def index
        family_relations = FamilyRelation.joins(family: :universe)
        family_relations = family_relations.where(universes: { user_id: current_user.id }) unless current_user.admin?

        render json: FamilyRelationBlueprint.render(family_relations)
      end

      def show
        render json: FamilyRelationBlueprint.render(@family_relation)
      end

      def create
        family_relation = FamilyRelation.new(family_relation_attributes)

        if family_relation.save
          render json: FamilyRelationBlueprint.render(family_relation), status: :created
        else
          render json: { errors: family_relation.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @family_relation.update(family_relation_attributes)
          render json: FamilyRelationBlueprint.render(@family_relation)
        else
          render json: { errors: @family_relation.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @family_relation.destroy

        head :no_content
      end

      private

      def set_family_relation
        scope = FamilyRelation.joins(family: :universe)
        scope = scope.where(universes: { user_id: current_user.id }) unless current_user.admin?
        @family_relation = scope.find(params[:id])
      end

      def family_relation_attributes
        attributes = family_relation_params
        attributes[:family] = editable_families.find(attributes.delete(:family_id)) if attributes.key?(:family_id)
        if attributes.key?(:related_family_id)
          attributes[:related_family] = editable_families.find(attributes.delete(:related_family_id))
        end
        attributes
      end

      def family_relation_params
        params.require(:family_relation).permit(:family_id, :related_family_id, :relation_type)
      end

      def editable_families
        current_user.admin? ? Family.all : current_user.families
      end
    end
  end
end
