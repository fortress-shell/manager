Rails.application.routes.draw do
  constraints subdomain: 'sidekiq' do
    mount Sidekiq::Web => '/'
  end
  get 'sessions/index'
  namespace :v1 do
    constraints subdomain: 'www' do

    end
    constraints subdomain: 'ci' do

    end
    constraints subdomain: 'support' do

    end
    constraints subdomain: 'api' do

    end
    constraints subdomain: 'webhooks' do

    end
  end
end
