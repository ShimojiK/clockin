Rails.application.routes.draw do
  root "time_logs#new"

  resources :time_logs, only: [:index, :new, :create, :update] do
    resources :comments, only: [:index]
  end
end
