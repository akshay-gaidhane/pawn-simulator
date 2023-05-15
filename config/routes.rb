Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root :to => "chess_boards#index"
  resources :chess_boards do
    member do
      post :move
    end
  end
end
