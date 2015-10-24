class User::TimeLogsController < User::Base
  def index
    @condition = current_user.time_logs.exists?(end_at: nil)
    @time_logs = current_user.time_logs
  end

  def create
    time_log = current_user.time_logs.find_or_initialize_by(end_at: nil)
    time = Time.now
    if time_log.start_at
      time_log.update(end_at: time, original_end_at: time)
    else
      time_log.start_at = time
      time_log.original_start_at = time
      time_log.save
    end
    redirect_to time_logs_path
  end

  def update
    time_log = current_user.time_logs.find(params[:id])
    old_end = time_log.end_at

    status = if time_log.shorten?(time_log_params)
               time_log.user_updatable_status
             else
               :lengthen
             end
    info = if status == :ok
             time_log.update_with_create_user_comment(time_log_params, old_end)
           else
             { alert: view_context.unupdatable_message(status) }
           end
    redirect_to time_log_comments_path(params[:id]), info
  end

  private
  def time_log_params
    params.require(:time_log).permit(:end_at)
  end
end
