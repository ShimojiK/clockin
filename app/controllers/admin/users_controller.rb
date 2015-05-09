class Admin::UsersController < Admin::Base
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    user = User.create(new_user_params)
    if user
      redirect_to admin_users_path, notice: "ユーザを作成しました"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    if user.update(edit_user_params)
      redirect_to admin_user_time_logs_path(user), notice: "ユーザを更新しました"
    end
  end

  private
  def new_user_params
    edit_user_params.merge(params.require(:user).permit(:password))
  end

  def edit_user_params
    params.require(:user).permit(:name, :desc, :account)
  end
end
