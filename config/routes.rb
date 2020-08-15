Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :short_urls, only: [:index, :show, :create, :destroy]
      resources :users, only: :create
      resources :tokens, only: :create
    end
  end
end
