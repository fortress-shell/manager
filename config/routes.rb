Rails.application.routes.draw do
  constraints subdomain: 'sidekiq' do
    mount Sidekiq::Web => '/'
  end
  defaults format: 'json' do
    namespace :v1 do
      resources :webhooks, only: :create
      resources :subscriptions, only: [:index, :create, :destroy]
      resources :sessions, only: [:index, :create] do
        post 'logout', on: :collection
      end
      resources :projects, only: [:index, :show] do
        resources :builds, only: [:index, :show] do
          member do
            patch 'restart'
            patch 'cancel'
            get 'logs'
          end
        end
      end
      resources :users, only: [] do
        delete 'suicide', on: :collection
      end
      constraints subdomain: 'rpc' do
        resources :results, only: :create
      end
    end
  end
end
