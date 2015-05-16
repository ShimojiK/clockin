class Admin::TimeLogsController < Admin::Base
  def index
    @user = User.find(params[:user_id])
    @time_logs = @user.time_logs
  end

  def update
    time_log = TimeLog.find(params[:id])
    old_end = time_log.end_at
    redirect_to :back, time_log.update_with_create_admin_comment(time_log_params, old_end, current_admin)
  end

  private
  def time_log_params
    params.require(:time_log).permit(:start_at, :end_at)
  end
end
