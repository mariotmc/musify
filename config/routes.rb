Rails.application.routes.draw do
  root "lobbies#index"

  resources :lobbies, param: :code, only: [:index, :create, :show]

  resources :players, only: [:new, :create, :update, :destroy]

  resources :games, only: [:update] do
    member do
      post "ready"
      post "unready"
    end
    resources :rounds, only: [:create, :update] do
      member do
        post "ready"
        post "unready"
      end
      resources :songs, only: [:new, :create]
      resources :guesses, only: [:create]
    end
  end

  resources :song_searches, only: [:index, :create]

  get "up" => "rails/health#show", as: :rails_health_check
end
