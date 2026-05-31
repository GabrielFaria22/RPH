Rails.application.routes.draw do
  if Rails.env.development?
    mount Rswag::Api::Engine => '/api-docs'
    mount Rswag::Ui::Engine => '/api-docs'
  end

  namespace :api do
    namespace :v1 do
      namespace :auth do
        post 'signup', to: 'registrations#create'
        post 'login', to: 'sessions#create'
        delete 'logout', to: 'sessions#destroy'
      end

      resources :people, except: %i[new edit]
      resources :universes, except: %i[new edit] do
        get :mine, on: :collection
      end
      resources :worlds, except: %i[new edit] do
        get :mine, on: :collection
      end
      resources :characters, except: %i[new edit] do
        get :mine, on: :collection
      end
      resources :families, except: %i[new edit] do
        get :mine, on: :collection
      end
      resources :factions, except: %i[new edit] do
        get :mine, on: :collection
      end
      resources :family_relations, except: %i[new edit]
      resources :faction_relations, except: %i[new edit]
      resources :family_trees, except: %i[new edit] do
        get :mine, on: :collection
      end
      resources :relations, except: %i[new edit]
    end
  end

  if Rails.env.development?
    require 'sidekiq/web'
    # Optionally, mount under /api/sidekiq for consistency
    mount Sidekiq::Web => '/api/sidekiq'
  end
end
