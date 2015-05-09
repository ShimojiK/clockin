class Admin::TimeLogsController < Admin::Base
  def index
    @user = User.find(params[:user_id])
    @time_logs = @user.time_logs
  end

  def update
  end
end
