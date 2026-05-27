module Api
  module V1
    class PeopleController < BaseController
      before_action :authenticate_user!
      before_action :set_person, only: %i[show update destroy]

      def index
        render json: PersonBlueprint.render(current_user.people)
      end

      def show
        render json: PersonBlueprint.render(@person)
      end

      def create
        person = current_user.people.build(person_params)

        if person.save
          render json: PersonBlueprint.render(person), status: :created
        else
          render json: { errors: person.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @person.update(person_params)
          render json: PersonBlueprint.render(@person)
        else
          render json: { errors: @person.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @person.destroy

        head :no_content
      end

      private

      def set_person
        @person = current_user.people.find(params[:id])
      end

      def person_params
        params.require(:person).permit(:first_name, :last_name, :email, :phone)
      end
    end
  end
end
