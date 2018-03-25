Rails.application.routes.draw do
  constraints subdomain: 'sidekiq' do
    mount Sidekiq::Web => '/'
  end
  namespace :v1 do
    constraints subdomain: 'api' do
      resources :sessions, only: [:index, :create, :destroy]
      resources :projects, only: :index do
        resources :builds, only: :index do
          member do
            patch 'restart'
            patch 'cancel'
          end
          resources :logs, only: :index
        end
      end
    end
    constraints subdomain: 'rpc' do
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
    constraints subdomain: 'webhooks' do
      resources :webhooks, only: :create
    end
  end
end
