# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'API V1', type: :request do
  let(:user) { create(:user) }
  let(:Authorization) { "Bearer #{Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first}" }

  path '/api/v1/auth/signup' do
    post 'Create an account' do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'
      description 'Registers a new user. The email must be unique and the password must be 10 to 128 characters.'
      parameter name: :payload, in: :body, schema: { '$ref' => '#/components/schemas/SignupRequest' }

      response '200', 'user created' do
        schema type: :object,
          properties: {
            status: { '$ref' => '#/components/schemas/AuthStatus' },
            data: { '$ref' => '#/components/schemas/User' }
          }

        let(:payload) do
          {
            user: {
              email: 'swagger-signup@example.com',
              password: 'password123',
              password_confirmation: 'password123'
            }
          }
        end

        run_test!
      end

      response '422', 'invalid signup data' do
        schema type: :object,
          properties: {
            status: { '$ref' => '#/components/schemas/AuthStatus' },
            errors: { type: :array, items: { type: :string } }
          }

        let(:payload) do
          {
            user: {
              email: 'bad-email@example.com',
              password: 'short',
              password_confirmation: 'short'
            }
          }
        end

        run_test!
      end
    end
  end

  path '/api/v1/auth/login' do
    post 'Log in' do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'
      description 'Authenticates a user and returns a JWT token. Use the token in the Authorization header for protected endpoints.'
      parameter name: :payload, in: :body, schema: { '$ref' => '#/components/schemas/LoginRequest' }

      response '200', 'logged in' do
        schema type: :object,
          properties: {
            status: { '$ref' => '#/components/schemas/AuthStatus' },
            data: { '$ref' => '#/components/schemas/User' },
            token: { type: :string, description: 'JWT bearer token.' }
          }

        before { create(:user, email: 'swagger-login@example.com', password: 'password123') }

        let(:payload) { { user: { email: 'swagger-login@example.com', password: 'password123' } } }

        run_test!
      end

      response '401', 'invalid credentials' do
        schema type: :object,
          properties: {
            status: { '$ref' => '#/components/schemas/AuthStatus' }
          }

        let(:payload) { { user: { email: 'missing@example.com', password: 'wrongpassword' } } }

        run_test!
      end
    end
  end

  path '/api/v1/auth/logout' do
    delete 'Log out' do
      tags 'Auth'
      security [bearerAuth: []]
      produces 'application/json'
      description 'Requires a bearer token and returns a confirmation message.'

      response '200', 'logged out' do
        schema type: :object,
          properties: {
            status: { '$ref' => '#/components/schemas/AuthStatus' }
          }

        run_test!
      end
    end
  end

  path '/api/v1/people' do
    get 'List people' do
      tags 'People'
      security [bearerAuth: []]
      produces 'application/json'
      description 'Lists people owned by the authenticated user.'

      response '200', 'people listed' do
        schema type: :array, items: { '$ref' => '#/components/schemas/Person' }

        before { create(:person, user: user) }

        run_test!
      end
    end

    post 'Create a person' do
      tags 'People'
      security [bearerAuth: []]
      consumes 'application/json'
      produces 'application/json'
      description 'Creates a person for the authenticated user.'
      parameter name: :payload, in: :body, schema: { '$ref' => '#/components/schemas/PersonRequest' }

      response '201', 'person created' do
        schema '$ref' => '#/components/schemas/Person'

        let(:payload) do
          {
            person: {
              first_name: 'Grace',
              last_name: 'Hopper',
              email: 'grace-swagger@example.com',
              phone: '555-0200'
            }
          }
        end

        run_test!
      end
    end
  end

  path '/api/v1/people/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Person ID.'

    get 'Show a person' do
      tags 'People'
      security [bearerAuth: []]
      produces 'application/json'
      description 'Returns one person owned by the authenticated user.'

      response '200', 'person found' do
        schema '$ref' => '#/components/schemas/Person'

        let(:id) { create(:person, user: user).id }

        run_test!
      end
    end

    patch 'Update a person' do
      tags 'People'
      security [bearerAuth: []]
      consumes 'application/json'
      produces 'application/json'
      description 'Updates any supplied person fields.'
      parameter name: :payload, in: :body, schema: { '$ref' => '#/components/schemas/PersonRequest' }

      response '200', 'person updated' do
        schema '$ref' => '#/components/schemas/Person'

        let(:id) { create(:person, user: user).id }
        let(:payload) { { person: { first_name: 'Updated', last_name: 'Person', email: 'updated@example.com' } } }

        run_test!
      end
    end

    delete 'Delete a person' do
      tags 'People'
      security [bearerAuth: []]
      description 'Deletes a person owned by the authenticated user.'

      response '204', 'person deleted' do
        let(:id) { create(:person, user: user).id }

        run_test!
      end
    end
  end

  path '/api/v1/universes' do
    get 'List universes' do
      tags 'Universes'
      security [bearerAuth: []]
      produces 'application/json'
      description 'Lists universes owned by the authenticated user.'

      response '200', 'universes listed' do
        schema type: :array, items: { '$ref' => '#/components/schemas/Universe' }

        before { create(:universe, user: user) }

        run_test!
      end
    end

    post 'Create a universe' do
      tags 'Universes'
      security [bearerAuth: []]
      consumes 'application/json'
      produces 'application/json'
      description 'Creates a universe. Only name is required.'
      parameter name: :payload, in: :body, schema: { '$ref' => '#/components/schemas/UniverseRequest' }

      response '201', 'universe created' do
        schema '$ref' => '#/components/schemas/Universe'

        let(:payload) { { universe: { name: 'Prime Continuity', description: 'Main continuity.' } } }

        run_test!
      end
    end
  end

  path '/api/v1/universes/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Universe ID.'

    get 'Show a universe' do
      tags 'Universes'
      security [bearerAuth: []]
      produces 'application/json'
      description 'Returns one universe owned by the authenticated user.'

      response '200', 'universe found' do
        schema '$ref' => '#/components/schemas/Universe'

        let(:id) { create(:universe, user: user).id }

        run_test!
      end
    end

    patch 'Update a universe' do
      tags 'Universes'
      security [bearerAuth: []]
      consumes 'application/json'
      produces 'application/json'
      description 'Updates the universe name and/or description.'
      parameter name: :payload, in: :body, schema: { '$ref' => '#/components/schemas/UniverseRequest' }

      response '200', 'universe updated' do
        schema '$ref' => '#/components/schemas/Universe'

        let(:id) { create(:universe, user: user).id }
        let(:payload) { { universe: { name: 'Updated Continuity', description: 'Changed notes.' } } }

        run_test!
      end
    end

    delete 'Delete a universe' do
      tags 'Universes'
      security [bearerAuth: []]
      description 'Deletes a universe and its dependent worlds and characters.'

      response '204', 'universe deleted' do
        let(:id) { create(:universe, user: user).id }

        run_test!
      end
    end
  end

  path '/api/v1/worlds' do
    get 'List worlds' do
      tags 'Worlds'
      security [bearerAuth: []]
      produces 'application/json'
      description 'Lists worlds across the authenticated user universes.'

      response '200', 'worlds listed' do
        schema type: :array, items: { '$ref' => '#/components/schemas/World' }

        before { create(:world, universe: create(:universe, user: user)) }

        run_test!
      end
    end

    post 'Create a world' do
      tags 'Worlds'
      security [bearerAuth: []]
      consumes 'application/json'
      produces 'application/json'
      description 'Creates a world inside an existing universe owned by the authenticated user.'
      parameter name: :payload, in: :body, schema: { '$ref' => '#/components/schemas/WorldRequest' }

      response '201', 'world created' do
        schema '$ref' => '#/components/schemas/World'

        let(:universe) { create(:universe, user: user) }
        let(:payload) { { world: { name: 'Eldoria', description: 'Floating cities.', universe_id: universe.id } } }

        run_test!
      end
    end
  end

  path '/api/v1/worlds/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'World ID.'

    get 'Show a world' do
      tags 'Worlds'
      security [bearerAuth: []]
      produces 'application/json'
      description 'Returns one world owned through the authenticated user universe.'

      response '200', 'world found' do
        schema '$ref' => '#/components/schemas/World'

        let(:id) { create(:world, universe: create(:universe, user: user)).id }

        run_test!
      end
    end

    patch 'Update a world' do
      tags 'Worlds'
      security [bearerAuth: []]
      consumes 'application/json'
      produces 'application/json'
      description 'Updates world fields. universe_id may move the world to another universe owned by the user.'
      parameter name: :payload, in: :body, schema: { '$ref' => '#/components/schemas/WorldRequest' }

      response '200', 'world updated' do
        schema '$ref' => '#/components/schemas/World'

        let(:universe) { create(:universe, user: user) }
        let(:id) { create(:world, universe: universe).id }
        let(:payload) { { world: { name: 'Updated World', description: 'New notes.', universe_id: universe.id } } }

        run_test!
      end
    end

    delete 'Delete a world' do
      tags 'Worlds'
      security [bearerAuth: []]
      description 'Deletes a world. Existing characters are kept and their world_id is cleared.'

      response '204', 'world deleted' do
        let(:id) { create(:world, universe: create(:universe, user: user)).id }

        run_test!
      end
    end
  end

  path '/api/v1/characters' do
    get 'List characters' do
      tags 'Characters'
      security [bearerAuth: []]
      produces 'application/json'
      description 'Lists characters across the authenticated user universes, including attachment metadata and outgoing relations.'

      response '200', 'characters listed' do
        schema type: :array, items: { '$ref' => '#/components/schemas/Character' }

        before { create(:character, universe: create(:universe, user: user)) }

        run_test!
      end
    end

    post 'Create a character' do
      tags 'Characters'
      security [bearerAuth: []]
      consumes 'application/json', 'multipart/form-data'
      produces 'application/json'
      description 'Creates a character. Send JSON for text fields, or multipart/form-data when uploading portrait_image and/or cover_image.'
      parameter name: :payload, in: :body, schema: { '$ref' => '#/components/schemas/CharacterRequest' }

      response '201', 'character created' do
        schema '$ref' => '#/components/schemas/Character'

        let(:universe) { create(:universe, user: user) }
        let(:world) { create(:world, universe: universe) }
        let(:payload) do
          {
            character: {
              name: 'Aster',
              full_name: 'Aster Vale Solarin',
              nickname: 'The Starborn',
              age: '1000001',
              appearance: 'Silver hair and amber eyes.',
              occupation: 'Chronomancer',
              description: 'A guarded scholar.',
              story: 'Born before the first empire.',
              universe_id: universe.id,
              world_id: world.id
            }
          }
        end

        run_test!
      end
    end
  end

  path '/api/v1/characters/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Character ID.'

    get 'Show a character' do
      tags 'Characters'
      security [bearerAuth: []]
      produces 'application/json'
      description 'Returns one character owned through the authenticated user universe.'

      response '200', 'character found' do
        schema '$ref' => '#/components/schemas/Character'

        let(:id) { create(:character, universe: create(:universe, user: user)).id }

        run_test!
      end
    end

    patch 'Update a character' do
      tags 'Characters'
      security [bearerAuth: []]
      consumes 'application/json', 'multipart/form-data'
      produces 'application/json'
      description 'Updates character fields. Use multipart/form-data to replace portrait_image or cover_image.'
      parameter name: :payload, in: :body, schema: { '$ref' => '#/components/schemas/CharacterRequest' }

      response '200', 'character updated' do
        schema '$ref' => '#/components/schemas/Character'

        let(:universe) { create(:universe, user: user) }
        let(:id) { create(:character, universe: universe).id }
        let(:payload) { { character: { name: 'Updated Aster', universe_id: universe.id, age: '1000002' } } }

        run_test!
      end
    end

    delete 'Delete a character' do
      tags 'Characters'
      security [bearerAuth: []]
      description 'Deletes a character and its relation records.'

      response '204', 'character deleted' do
        let(:id) { create(:character, universe: create(:universe, user: user)).id }

        run_test!
      end
    end
  end

  path '/api/v1/relations' do
    get 'List relations' do
      tags 'Relations'
      security [bearerAuth: []]
      produces 'application/json'
      description 'Lists outgoing character relation records owned by the authenticated user.'

      response '200', 'relations listed' do
        schema type: :array, items: { '$ref' => '#/components/schemas/Relation' }

        before do
          universe = create(:universe, user: user)
          character = create(:character, universe: universe)
          related_character = create(:character, universe: universe)
          create(:relation, character: character, related_character: related_character)
        end

        run_test!
      end
    end

    post 'Create a relation' do
      tags 'Relations'
      security [bearerAuth: []]
      consumes 'application/json'
      produces 'application/json'
      description 'Creates a directed relation from one character to another character owned by the same user.'
      parameter name: :payload, in: :body, schema: { '$ref' => '#/components/schemas/RelationRequest' }

      response '201', 'relation created' do
        schema '$ref' => '#/components/schemas/Relation'

        let(:universe) { create(:universe, user: user) }
        let(:character) { create(:character, universe: universe) }
        let(:related_character) { create(:character, universe: universe) }
        let(:payload) do
          {
            relation: {
              character_id: character.id,
              related_character_id: related_character.id,
              relation_type: 'friend'
            }
          }
        end

        run_test!
      end
    end
  end

  path '/api/v1/relations/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Relation ID.'

    get 'Show a relation' do
      tags 'Relations'
      security [bearerAuth: []]
      produces 'application/json'
      description 'Returns one relation owned through the source character universe.'

      response '200', 'relation found' do
        schema '$ref' => '#/components/schemas/Relation'

        let(:id) do
          universe = create(:universe, user: user)
          character = create(:character, universe: universe)
          related_character = create(:character, universe: universe)
          create(:relation, character: character, related_character: related_character).id
        end

        run_test!
      end
    end

    patch 'Update a relation' do
      tags 'Relations'
      security [bearerAuth: []]
      consumes 'application/json'
      produces 'application/json'
      description 'Updates relation_type and/or the source or target character.'
      parameter name: :payload, in: :body, schema: { '$ref' => '#/components/schemas/RelationRequest' }

      response '200', 'relation updated' do
        schema '$ref' => '#/components/schemas/Relation'

        let(:universe) { create(:universe, user: user) }
        let(:character) { create(:character, universe: universe) }
        let(:related_character) { create(:character, universe: universe) }
        let(:id) { create(:relation, character: character, related_character: related_character).id }
        let(:payload) { { relation: { relation_type: 'ally' } } }

        run_test!
      end
    end

    delete 'Delete a relation' do
      tags 'Relations'
      security [bearerAuth: []]
      description 'Deletes a relation record.'

      response '204', 'relation deleted' do
        let(:id) do
          universe = create(:universe, user: user)
          character = create(:character, universe: universe)
          related_character = create(:character, universe: universe)
          create(:relation, character: character, related_character: related_character).id
        end

        run_test!
      end
    end
  end
end
