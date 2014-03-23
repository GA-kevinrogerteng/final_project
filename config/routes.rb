require 'sidekiq/web'

FinalProject::Application.routes.draw do
  get '/posts', to: 'posts#index'

  mount Sidekiq::Web, at: '/Sidekiq'
end
