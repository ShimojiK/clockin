Rails.application.routes.draw do
  root "time_logs#new"

  resource :admins, only: [:create], controller: "admin/admins" do
    get "signin" => "admin/admins#signin"
    delete "signout" => "admin/admins#signout"
  end

  # for admin
  namespace :admin do
  end

  resource :users, only: [:create, :edit, :update] do
    get "signin" => "users#signin"
    delete "signout" => "users#signout"
  end

  # for logined user
  resources :time_logs, only: [:index, :new, :create, :update] do
    resources :comments, only: [:index]
  end

end
