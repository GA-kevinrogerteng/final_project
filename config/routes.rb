require 'sidekiq/web'

FinalProject::Application.routes.draw do
  resources :posts
  root to: "posts#index"

  mount Sidekiq::Web, at: '/Sidekiq'
end
