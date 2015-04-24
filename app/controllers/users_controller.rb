class UsersController < ApplicationController
  skip_before_action :user?, only: [:signin, :create]
  skip_before_action :password_changed?, only: [:signin, :create, :edit, :update]

  def signin
    if current_user
      redirect_to root_path
    end
    @user = User.new
  end

  def create
    user = User.find_by(account: signin_params[:account])
    if user && user.authenticate(signin_params[:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      redirect_to signin_users_path, alert: "アカウント名またはパスワードが間違っています"
    end
  end

  def edit
    @user = current_user
  end

  def update
    if current_user.update(password_params.merge(password_changed: true))
      redirect_to root_path, notice: "パスワードを更新しました"
    else
      redirect_to :back
    end
  end

  def signout
    reset_session
    redirect_to signin_users_path, notice: "ログアウトしました"
  end

  private
  def signin_params
    params.permit(:account, :password)
  end

  def password_params
    params.permit(:password)
  end
end
