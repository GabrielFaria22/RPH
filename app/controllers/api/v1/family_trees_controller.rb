module Api
  module V1
    class FamilyTreesController < BaseController
      before_action :authenticate_user!
      before_action :set_family_tree, only: %i[show update destroy]

      def index
        family_trees = search_by_name(current_user.admin? ? FamilyTree.all : FamilyTree.visible_to(current_user))

        render json: FamilyTreeBlueprint.render(family_trees, current_user: current_user)
      end

      def mine
        family_trees = search_by_name(current_user.family_trees)

        render json: FamilyTreeBlueprint.render(family_trees, current_user: current_user)
      end

      def show
        render json: FamilyTreeBlueprint.render(@family_tree, current_user: current_user)
      end

      def create
        attributes = family_tree_params
        universe = current_user.universes.find(attributes.delete(:universe_id))
        family_tree = universe.family_trees.build(family_tree_attributes(attributes, universe))

        if family_tree.save
          render json: FamilyTreeBlueprint.render(family_tree, current_user: current_user), status: :created
        else
          render json: { errors: family_tree.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        return forbidden unless owns_family_tree?(@family_tree)

        attributes = family_tree_params
        if attributes.key?(:universe_id)
          attributes[:universe] = current_user.universes.find(attributes.delete(:universe_id))
        end

        universe = attributes[:universe] || @family_tree.universe

        if @family_tree.update(family_tree_attributes(attributes, universe))
          render json: FamilyTreeBlueprint.render(@family_tree, current_user: current_user)
        else
          render json: { errors: @family_tree.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        return forbidden unless owns_family_tree?(@family_tree)

        @family_tree.destroy

        head :no_content
      end

      private

      def set_family_tree
        scope = current_user.admin? ? FamilyTree.all : FamilyTree.visible_to(current_user)
        @family_tree = scope.find(params[:id])
      end

      def family_tree_params
        permitted = params.require(:family_tree).permit(:name, :description, :public, :universe_id, :family_id)
        return permitted unless params[:family_tree].key?(:layout)

        permitted[:layout] = normalize_layout(params[:family_tree][:layout])
        permitted
      end

      def normalize_layout(layout)
        return layout.to_unsafe_h if layout.respond_to?(:to_unsafe_h)

        layout
      end

      def family_tree_attributes(attributes, universe)
        if attributes.key?(:family_id)
          family_id = attributes.delete(:family_id)
          attributes[:family] = family_id.present? ? universe.families.find(family_id) : nil
        end

        attributes
      end

      def search_by_name(scope)
        return scope unless params[:q].present?

        scope.where('family_trees.name ILIKE ?', "%#{params[:q]}%")
      end

      def owns_family_tree?(family_tree)
        current_user.admin? || family_tree.universe.user_id == current_user.id
      end
    end
  end
end
