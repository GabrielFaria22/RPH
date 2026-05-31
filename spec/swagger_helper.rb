# frozen_string_literal: true

require 'rails_helper'
require 'rswag/specs'

RSpec.configure do |config|
  config.openapi_root = Rails.root.join('swagger').to_s

  config.openapi_specs = {
    'v1/openapi.yaml' => {
      openapi: '3.0.3',
      info: {
        title: 'RPH API',
        version: 'v1',
        description: 'JSON API for authentication, people, universes, worlds, characters, and character relations.'
      },
      servers: [
        {
          url: 'http://localhost:3001',
          description: 'Local Docker development server'
        }
      ],
      components: {
        securitySchemes: {
          bearerAuth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: 'JWT',
            description: 'JWT returned by POST /api/v1/auth/login. Send as: Bearer <token>.'
          }
        },
        schemas: {
          SignupRequest: {
            type: :object,
            required: ['user'],
            properties: {
              user: {
                type: :object,
                required: %w[email password password_confirmation],
                properties: {
                  email: { type: :string, format: :email, description: 'Email used to log in.', example: 'writer@example.com' },
                  password: { type: :string, format: :password, description: 'Password. Must be 10 to 128 characters.', example: 'password123' },
                  password_confirmation: { type: :string, format: :password, description: 'Must exactly match password.', example: 'password123' }
                }
              }
            }
          },
          LoginRequest: {
            type: :object,
            required: ['user'],
            properties: {
              user: {
                type: :object,
                required: %w[email password],
                properties: {
                  email: { type: :string, format: :email, description: 'Registered account email.', example: 'writer@example.com' },
                  password: { type: :string, format: :password, description: 'Account password.', example: 'password123' }
                }
              }
            }
          },
          PersonRequest: {
            type: :object,
            required: ['person'],
            properties: {
              person: {
                type: :object,
                required: %w[first_name last_name email],
                properties: {
                  first_name: { type: :string, description: 'Required given name.', example: 'Grace' },
                  last_name: { type: :string, description: 'Required family name.', example: 'Hopper' },
                  email: { type: :string, format: :email, description: 'Required valid email.', example: 'grace@example.com' },
                  phone: { type: :string, nullable: true, description: 'Optional phone number.', example: '555-0200' }
                }
              }
            }
          },
          UniverseRequest: {
            type: :object,
            required: ['universe'],
            properties: {
              universe: {
                type: :object,
                required: ['name'],
                properties: {
                  name: { type: :string, description: 'Required universe name.', example: 'The Prime Continuity' },
                  description: { type: :string, nullable: true, description: 'Optional notes about the setting or continuity.', example: 'A shared continuity for cosmic stories.' },
                  public: { type: :boolean, description: 'Whether other users can discover and read this universe. Defaults to false/private.', example: false },
                  portrait_image: {
                    type: :string,
                    format: :binary,
                    description: 'Optional vertical portrait image. Use multipart/form-data. Max 5 MB. Allowed: JPEG, PNG, WebP, GIF.'
                  },
                  cover_image: {
                    type: :string,
                    format: :binary,
                    description: 'Optional horizontal cover image. Use multipart/form-data. Max 20 MB. Allowed: JPEG, PNG, WebP, GIF.'
                  },
                  misc_images: {
                    type: :array,
                    maxItems: 8,
                    description: 'Optional misc image gallery. Use multipart/form-data. Each image max 5 MB. Allowed: JPEG, PNG, WebP, GIF.',
                    items: { type: :string, format: :binary }
                  }
                }
              }
            }
          },
          WorldRequest: {
            type: :object,
            required: ['world'],
            properties: {
              world: {
                type: :object,
                required: %w[name universe_id],
                properties: {
                  name: { type: :string, description: 'Required world name.', example: 'Eldoria' },
                  description: { type: :string, nullable: true, description: 'Optional lore, culture, or geography notes.', example: 'A moonlit realm of floating cities.' },
                  public: { type: :boolean, description: 'Whether other users can discover and read this world. Defaults to false/private.', example: false },
                  universe_id: { type: :integer, description: 'Required ID of a universe owned by the current user.', example: 1 },
                  portrait_image: {
                    type: :string,
                    format: :binary,
                    description: 'Optional vertical portrait image. Use multipart/form-data. Max 5 MB. Allowed: JPEG, PNG, WebP, GIF.'
                  },
                  cover_image: {
                    type: :string,
                    format: :binary,
                    description: 'Optional horizontal cover image. Use multipart/form-data. Max 20 MB. Allowed: JPEG, PNG, WebP, GIF.'
                  },
                  misc_images: {
                    type: :array,
                    maxItems: 8,
                    description: 'Optional misc image gallery. Use multipart/form-data. Each image max 5 MB. Allowed: JPEG, PNG, WebP, GIF.',
                    items: { type: :string, format: :binary }
                  }
                }
              }
            }
          },
          CharacterRequest: {
            type: :object,
            required: ['character'],
            properties: {
              character: {
                type: :object,
                required: %w[name universe_id],
                properties: {
                  name: { type: :string, description: 'Required display name.', example: 'Aster' },
                  full_name: { type: :string, nullable: true, description: 'Optional formal name.', example: 'Aster Vale Solarin' },
                  nickname: { type: :string, nullable: true, description: 'Optional alias or nickname.', example: 'The Starborn' },
                  age: { type: :string, nullable: true, description: 'Use text for extremely large or descriptive ages.', example: '1000001' },
                  appearance: { type: :string, nullable: true, description: 'Short visual description.', example: 'Silver hair and amber eyes.' },
                  occupation: { type: :string, nullable: true, description: 'Role, job, class, or social function.', example: 'Chronomancer' },
                  description: { type: :string, nullable: true, description: 'General notes about the character.', example: 'A guarded scholar with a dry sense of humor.' },
                  story: { type: :string, nullable: true, description: 'Backstory, plot arc, or biography.', example: 'Born before the first empire.' },
                  public: { type: :boolean, description: 'Whether other users can discover and read this character. Defaults to false/private.', example: false },
                  universe_id: { type: :integer, description: 'Required ID of a universe owned by the current user.', example: 1 },
                  world_id: { type: :integer, nullable: true, description: 'Optional ID of a world in the same universe.', example: 1 },
                  portrait_image: {
                    type: :string,
                    format: :binary,
                    description: 'Optional vertical portrait image. Use multipart/form-data. Max 5 MB. Allowed: JPEG, PNG, WebP, GIF.'
                  },
                  cover_image: {
                    type: :string,
                    format: :binary,
                    description: 'Optional horizontal cover image. Use multipart/form-data. Max 20 MB. Allowed: JPEG, PNG, WebP, GIF.'
                  },
                  misc_images: {
                    type: :array,
                    maxItems: 8,
                    description: 'Optional misc image gallery. Use multipart/form-data. Each image max 5 MB. Allowed: JPEG, PNG, WebP, GIF.',
                    items: { type: :string, format: :binary }
                  }
                }
              }
            }
          },
          RelationRequest: {
            type: :object,
            required: ['relation'],
            properties: {
              relation: {
                type: :object,
                required: %w[character_id related_character_id relation_type],
                properties: {
                  character_id: { type: :integer, description: 'Required source character ID owned by the current user.', example: 1 },
                  related_character_id: { type: :integer, description: 'Required target character ID owned by the current user.', example: 2 },
                  relation_type: {
                    type: :string,
                    description: 'Required relationship type.',
                    enum: Relation::TYPES.values,
                    example: 'friend'
                  }
                }
              }
            }
          },
          ErrorResponse: {
            type: :object,
            properties: {
              errors: {
                type: :array,
                items: { type: :string },
                description: 'Human readable validation, authorization, or lookup errors.',
                example: ['Record not found']
              }
            }
          },
          AuthStatus: {
            type: :object,
            properties: {
              code: { type: :integer, example: 200 },
              message: { type: :string, example: 'Logged in successfully.' }
            }
          },
          User: {
            type: :object,
            properties: {
              id: { type: :integer, description: 'Internal user ID.', example: 1 },
              email: { type: :string, format: :email, description: 'User email address.', example: 'writer@example.com' },
              profile_type: { type: :string, enum: %w[regular admin], description: 'User profile type. Admin users may edit/delete any resource.', example: 'regular' },
              created_at: { type: :string, description: 'Creation timestamp.', example: '2026-05-27 13:34:33 UTC' },
              updated_at: { type: :string, description: 'Last update timestamp.', example: '2026-05-27 13:34:33 UTC' }
            }
          },
          Person: {
            type: :object,
            required: %w[id first_name last_name email],
            properties: {
              id: { type: :integer, description: 'Internal person ID.', example: 10 },
              first_name: { type: :string, description: 'Given name.', example: 'Grace' },
              last_name: { type: :string, description: 'Family name.', example: 'Hopper' },
              email: { type: :string, format: :email, description: 'Contact email address.', example: 'grace@example.com' },
              phone: { type: :string, nullable: true, description: 'Optional phone number.', example: '555-0200' },
              created_at: { type: :string, description: 'Creation timestamp.', example: '2026-05-27 13:34:33 UTC' },
              updated_at: { type: :string, description: 'Last update timestamp.', example: '2026-05-27 13:34:33 UTC' }
            }
          },
          Universe: {
            type: :object,
            required: %w[id name],
            properties: {
              id: { type: :integer, description: 'Internal universe ID.', example: 1 },
              name: { type: :string, description: 'Required universe name.', example: 'The Prime Continuity' },
              description: { type: :string, nullable: true, description: 'Long-form setting notes.', example: 'A shared continuity for cosmic stories.' },
              public: { type: :boolean, description: 'Whether other users can discover and read this universe.', example: false },
              owned_by_current_user: { type: :boolean, description: 'True when the authenticated user owns this universe and may edit/delete it.', example: true },
              editable_by_current_user: { type: :boolean, description: 'True when the authenticated user can edit/delete this universe. True for owners and admins.', example: true },
              portrait_image: { '$ref' => '#/components/schemas/Attachment' },
              cover_image: { '$ref' => '#/components/schemas/Attachment' },
              misc_images: {
                type: :array,
                description: 'Up to 8 misc images attached to this universe.',
                maxItems: 8,
                items: { '$ref' => '#/components/schemas/Attachment' }
              },
              created_at: { type: :string, description: 'Creation timestamp.', example: '2026-05-27 13:34:33 UTC' },
              updated_at: { type: :string, description: 'Last update timestamp.', example: '2026-05-27 13:34:33 UTC' }
            }
          },
          World: {
            type: :object,
            required: %w[id name universe_id],
            properties: {
              id: { type: :integer, description: 'Internal world ID.', example: 1 },
              name: { type: :string, description: 'Required world name.', example: 'Eldoria' },
              description: { type: :string, nullable: true, description: 'World geography, culture, or lore notes.', example: 'A moonlit realm of floating cities.' },
              public: { type: :boolean, description: 'Whether other users can discover and read this world.', example: false },
              owned_by_current_user: { type: :boolean, description: 'True when the authenticated user owns this world and may edit/delete it.', example: true },
              editable_by_current_user: { type: :boolean, description: 'True when the authenticated user can edit/delete this world. True for owners and admins.', example: true },
              universe_id: { type: :integer, description: 'ID of the universe this world belongs to.', example: 1 },
              portrait_image: { '$ref' => '#/components/schemas/Attachment' },
              cover_image: { '$ref' => '#/components/schemas/Attachment' },
              misc_images: {
                type: :array,
                description: 'Up to 8 misc images attached to this world.',
                maxItems: 8,
                items: { '$ref' => '#/components/schemas/Attachment' }
              },
              created_at: { type: :string, description: 'Creation timestamp.', example: '2026-05-27 13:34:33 UTC' },
              updated_at: { type: :string, description: 'Last update timestamp.', example: '2026-05-27 13:34:33 UTC' }
            }
          },
          Attachment: {
            type: :object,
            nullable: true,
            properties: {
              filename: { type: :string, description: 'Uploaded file name.', example: 'portrait.png' },
              content_type: { type: :string, description: 'MIME type. Allowed: image/jpeg, image/png, image/webp, image/gif.', example: 'image/png' },
              byte_size: { type: :integer, description: 'File size in bytes.', example: 124_000 },
              url: { type: :string, description: 'Relative Active Storage blob URL.', example: '/rails/active_storage/blobs/redirect/...' }
            }
          },
          Character: {
            type: :object,
            required: %w[id name universe_id],
            properties: {
              id: { type: :integer, description: 'Internal character ID.', example: 1 },
              name: { type: :string, description: 'Required display name.', example: 'Aster' },
              full_name: { type: :string, nullable: true, description: 'Complete formal name.', example: 'Aster Vale Solarin' },
              nickname: { type: :string, nullable: true, description: 'Nickname, alias, or short title.', example: 'The Starborn' },
              age: { type: :string, nullable: true, description: 'Stored as text so very large or descriptive ages fit.', example: '1000001' },
              appearance: { type: :string, nullable: true, description: 'Short visual description.', example: 'Silver hair, amber eyes, ceremonial armor.' },
              occupation: { type: :string, nullable: true, description: 'Role, job, class, or social function.', example: 'Chronomancer' },
              description: { type: :string, nullable: true, description: 'General character notes.', example: 'A guarded scholar with a dry sense of humor.' },
              story: { type: :string, nullable: true, description: 'Backstory or narrative arc.', example: 'Born before the first empire, Aster remembers every version of history.' },
              public: { type: :boolean, description: 'Whether other users can discover and read this character.', example: false },
              owned_by_current_user: { type: :boolean, description: 'True when the authenticated user owns this character and may edit/delete it.', example: true },
              editable_by_current_user: { type: :boolean, description: 'True when the authenticated user can edit/delete this character. True for owners and admins.', example: true },
              universe_id: { type: :integer, description: 'ID of the universe this character belongs to.', example: 1 },
              world_id: { type: :integer, nullable: true, description: 'Optional ID of a world in the same universe.', example: 1 },
              portrait_image: { '$ref' => '#/components/schemas/Attachment' },
              cover_image: { '$ref' => '#/components/schemas/Attachment' },
              misc_images: {
                type: :array,
                description: 'Up to 8 misc images attached to this character.',
                maxItems: 8,
                items: { '$ref' => '#/components/schemas/Attachment' }
              },
              relations: {
                type: :array,
                description: 'Outgoing relations from this character to other characters.',
                items: { '$ref' => '#/components/schemas/Relation' }
              },
              created_at: { type: :string, description: 'Creation timestamp.', example: '2026-05-27 13:34:33 UTC' },
              updated_at: { type: :string, description: 'Last update timestamp.', example: '2026-05-27 13:34:33 UTC' }
            }
          },
          Relation: {
            type: :object,
            required: %w[id character_id related_character_id relation_type],
            properties: {
              id: { type: :integer, description: 'Internal relation ID.', example: 1 },
              character_id: { type: :integer, description: 'Source character ID.', example: 1 },
              related_character_id: { type: :integer, description: 'Target character ID.', example: 2 },
              relation_type: {
                type: :string,
                description: 'Relationship type between the source and target character.',
                enum: Relation::TYPES.values,
                example: 'friend'
              },
              created_at: { type: :string, description: 'Creation timestamp.', example: '2026-05-27 13:34:33 UTC' },
              updated_at: { type: :string, description: 'Last update timestamp.', example: '2026-05-27 13:34:33 UTC' }
            }
          }
        }
      }
    }
  }

  config.openapi_format = :yaml
end
