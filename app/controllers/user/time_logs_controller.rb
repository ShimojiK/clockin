class User::TimeLogsController < User::Base
  def index
    @time_logs = current_user.time_logs
  end

  # todo newはindex内に統合
  def new
    @time_log = current_user.time_logs.find_or_initialize_by(end_at: nil)
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
    redirect_to :back
  end

  # todo
  def update
    time_log = current_user.time_logs.find(params[:id])
    old_end = time_log.end_at
    if time_log.user_updatable?
      if time_log.update(time_log_param)
        if time_log.create_update_comment(old_end)
          redirect_to :back
        else
          redirect_to :back, notice: "コメントの投稿に失敗しました(時刻の変更には問題ありません)"
        end
      else
          redirect_to :back, alret: "更新に失敗しました"
      end
    else
      redirect_to :back, alert: "変更ができるのは打刻60分以内です"
    end
  end

  private
  def time_log_param
    params.require(:time_log).permit(:end_at)
  end
end
