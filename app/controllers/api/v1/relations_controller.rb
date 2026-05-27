module Api
  module V1
    class RelationsController < BaseController
      before_action :authenticate_user!
      before_action :set_relation, only: %i[show update destroy]

      def index
        relations = Relation
          .joins(character: :universe)
          .where(universes: { user_id: current_user.id })

        render json: RelationBlueprint.render(relations)
      end

      def show
        render json: RelationBlueprint.render(@relation)
      end

      def create
        relation = Relation.new(relation_attributes)

        if relation.save
          render json: RelationBlueprint.render(relation), status: :created
        else
          render json: { errors: relation.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @relation.update(relation_attributes)
          render json: RelationBlueprint.render(@relation)
        else
          render json: { errors: @relation.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @relation.destroy

        head :no_content
      end

      private

      def set_relation
        @relation = Relation
          .joins(character: :universe)
          .where(universes: { user_id: current_user.id })
          .find(params[:id])
      end

      def relation_attributes
        attributes = relation_params
        attributes[:character] = current_user.characters.find(attributes.delete(:character_id)) if attributes.key?(:character_id)
        if attributes.key?(:related_character_id)
          attributes[:related_character] = current_user.characters.find(attributes.delete(:related_character_id))
        end
        attributes
      end

      def relation_params
        params.require(:relation).permit(:character_id, :related_character_id, :relation_type)
      end
    end
  end
end
