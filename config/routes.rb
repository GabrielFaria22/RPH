Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :auth do
        devise_for :users,
          path: '',
          path_names: {
            sign_in: 'login',
            sign_out: 'logout',
            registration: 'signup'
          },
          controllers: {
            sessions: 'api/v1/auth/sessions',
            registrations: 'api/v1/auth/registrations'
          },
          skip: %i[sessions registrations passwords]

        devise_scope :user do
          post 'signup', to: 'registrations#create'
          post 'login', to: 'sessions#create'
          delete 'logout', to: 'sessions#destroy'
        end
      end

      resources :people, except: %i[new edit]
    end
  end

  if Rails.env.development?
    require 'sidekiq/web'
    # Optionally, mount under /api/sidekiq for consistency
    mount Sidekiq::Web => '/api/sidekiq'
  end
end
