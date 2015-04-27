Rails.application.routes.draw do
  root "user/time_logs#new"

  resource :admins, only: [:create], controller: "admin/admins" do
    get "signin" => "admin/admins#signin"
    delete "signout" => "admin/admins#signout"
  end

  # for admin
  namespace :admin do
    resources :users, only: [:index, :new, :create, :edit, :update] do
    end
  end

  resource :users, only: [:create, :edit, :update], module: :user do
    get "signin" => "users#signin"
    delete "signout" => "users#signout"
  end

  # for logined user
  resources :time_logs, only: [:index, :new, :create, :update], module: :user do
    resources :comments, only: [:index, :create]
  end

end
