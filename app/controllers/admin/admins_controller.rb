class Admin::AdminsController < Admin::Base
  skip_before_action :admin?, only: [:signin, :create]

  def signin
    if current_admin
      redirect_to admin_users_path
    else
      @admin = Admin.new
    end
  end

  def create
    admin = Admin.find_by(account: signin_params[:account])
    if admin && admin.authenticate(signin_params[:password])
      session[:admin_id] = admin.id
      redirect_to admin_root_path
    else
      redirect_to signin_admins_path, alert: "アカウント名またはパスワードが間違っています"
    end
  end

  def signout
    reset_session
    redirect_to signin_admins_path, notice: "ログアウトしました"
  end

  private
  def signin_params
    params.require(:admin).permit(:account, :password)
  end
end
