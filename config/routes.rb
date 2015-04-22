Rails.application.routes.draw do
  root "time_logs#new"

  resources :time_logs, only: [:index, :new, :create, :update] do
    resources :comments, only: [:index]
  end

  resource :users, only: [:create] do
    get "signin" => "users#signin"
    delete "signout" => "users#signout"
  end
end
