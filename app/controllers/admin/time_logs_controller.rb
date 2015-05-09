class Admin::TimeLogsController < Admin::Base
  def index
    @user = User.find(params[:user_id])
    @time_logs = @user.time_logs
  end

  def update
    time_log = TimeLog.find(params[:id])
    old_end = time_log.end_at
    if time_log.update(time_log_param)
      if time_log.create_update_comment(old_end)
        redirect_to :back
      else
        redirect_to :back, notice: "コメントの投稿に失敗しました(時刻の変更には問題ありません"
      end
    else
      redirect_to :back, alert: "更新に失敗しました"
    end
  end

  private
  def time_log_param
    params.require(:time_log).permit(:start_at, :end_at)
  end
end
