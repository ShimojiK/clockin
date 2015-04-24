class Admin::UsersController < Admin::Base
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    user = User.create(user_params)
    if user
      redirect_to admin_users_path
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id]).update(user_params)
    if user
      redirect_to admin_users_path
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :desc, :account, :password)
  end
end
