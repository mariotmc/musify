Rails.application.routes.draw do
  root "lobbies#index"

  resources :lobbies, param: :code, only: [:index, :new, :create, :show]

  resources :players, only: [:new, :create]

  resources :games, only: [:show] do
    resources :rounds, only: [:create] do
      resources :guesses, only: [:create]
    end
    resources :songs, only: [:create]
  end
end
