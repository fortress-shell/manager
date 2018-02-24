Rails.application.routes.draw do
  constraints subdomain: 'sidekiq' do
    mount Sidekiq::Web => '/'
  end
  get 'sessions/index'
  namespace :v1 do
    constraints subdomain: 'cloud' do

    end
    constraints subdomain: 'www' do

    end
    constraints subdomain: 'ci' do

    end
    constraints subdomain: 'support' do

    end
    constraints subdomain: 'rpc' do

    end
    constraints subdomain: 'admin' do

    end
    constraints subdomain: 'api' do

    end
    constraints subdomain: 'webhooks' do

    end
  end
end
