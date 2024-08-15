Rails.application.routes.draw do
  root "lobbies#index"

  resources :lobbies, param: :code, only: [:index, :create, :show]
  delete "lobbies", to: "lobbies#destroy"

  resources :players, only: [:new, :create, :destroy]

  resources :games, only: [:update] do
    resources :rounds, only: [:create] do
      resources :songs, only: [:new, :create]
      resources :guesses, only: [:create]
    end
  end
end
