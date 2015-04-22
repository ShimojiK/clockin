class UsersController < ApplicationController
  skip_before_action :user?, only: [:signin, :create]

  def signin
    if current_user
      redirect_to root_path
    end
  end

  def create
    user = User.find_by(account: signin_params[:account])
    if user && user.authenticate(signin_params[:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      redirect_to user_signin_path, alert: "アカウント名またはパスワードが間違っています"
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
end
