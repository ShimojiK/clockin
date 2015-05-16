Rails.application.routes.draw do
  root "user/time_logs#index"

  resource :admins, only: [:create], controller: "admin/admins" do
    get "signin" => "admin/admins#signin"
    delete "signout" => "admin/admins#signout"
  end

  # for admin
  namespace :admin do
    root "time_logs#index"
    resources :users, only: [:index, :new, :create, :edit, :update] do
      resources :time_logs, only: [:index, :update], shallow: true do
        resources :comments, only: [:index, :create]
      end
    end
  end

  resource :users, only: [:create, :edit, :update], module: :user do
    get "signin" => "users#signin"
    delete "signout" => "users#signout"
  end

  # for logined user
  resources :time_logs, only: [:index, :create, :update], module: :user do
    resources :comments, only: [:index, :create]
  end
end
