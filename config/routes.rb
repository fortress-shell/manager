Rails.application.routes.draw do
  constraints subdomain: 'sidekiq' do
    mount Sidekiq::Web => '/'
  end
  defaults format: 'json' do
    namespace :v1 do
      resources :sessions, only: [:index, :create] do
        collection do
          post 'logout'
        end
      end
      resources :subscriptions, only: [:index, :create, :destroy]
      resources :projects, only: :index do
        resources :builds, only: :index do
          member do
            patch 'restart'
            patch 'cancel'
          end
          resources :logs, only: :index
        end
      end
      resources :users, only: [] do
        delete 'suicide', on: :collection
      end
      resources :webhooks, only: [:create]
      constraints subdomain: 'api' do
        resources :projects, only: [] do
          resources :builds, only: [] do
            member do
              patch 'timeout'
              patch 'fail'
              patch 'success'
              patch 'error'
            end
          end
        end
      end
    end
  end
end
