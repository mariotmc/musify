Rails.application.routes.draw do
  root "lobbies#index"

  resources :lobbies, param: :code, only: [:index, :new, :create, :show]

  resources :players, only: [:new, :create, :destroy]

  resources :games, only: [:update] do
    resources :rounds, only: [:create] do
      resources :guesses, only: [:create]
    end
    resources :songs, only: [:create]
  end
end
