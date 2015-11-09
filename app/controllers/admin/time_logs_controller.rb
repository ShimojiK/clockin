class Admin::TimeLogsController < Admin::Base
  def index
    @user = User.find(params[:user_id])
    @target_month = target_month
    @time_logs = @user.time_logs.where(original_start_at: @target_month.all_month)
  end

  def show
    @time_log = TimeLog.find(params[:id])
  end

  def update
    @time_log = TimeLog.find(params[:id])
    if @time_log.update_with_create_admin_comment(time_log_params, current_admin)
      redirect_to admin_time_log_path(@time_log), { notice: "更新に成功しました" }
    else
      render 'show'
    end
  end

  private
  def time_log_params
    params.require(:time_log).permit(:start_at, :end_at)
  end

  def target_month
    params[:query].try {|q|
      year = q["date(1i)"]
      month = q["date(2i)"]
      Time.zone.local(year, month) if year && month
    } || Time.zone.now
  end
end
