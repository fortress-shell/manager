Rails.application.routes.draw do
  constraints subdomain: 'sidekiq' do
    mount Sidekiq::Web => '/'
  end

  defaults format: 'json' do
    namespace :v1 do
      resources :webhooks, only: [:create]

      resources :subscriptions, only: [:index, :create, :destroy]

      resources :sessions, only: [:index, :create] do
        collection do
          post 'logout'
        end
      end

      resources :projects, only: [:index, :show] do
        resources :builds, only: [:index, :show] do
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

      constraints subdomain: 'rpc' do
        resources :builds, only: [] do
          collection do
            patch 'timeout'
            patch 'start'
            patch 'fail'
            patch 'stoped'
            patch 'success'
            patch 'maintenance'
          end
        end
      end
    end
  end
end
