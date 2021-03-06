class User::TimeLogsController < User::Base
  def index
    @user = current_user
    @condition = @user.time_logs.exists?(end_at: nil)
    @target_month = target_month
    @time_logs = @user.time_logs.where(start_at: @target_month.all_month)
  end

  def show
    @time_log = current_user.time_logs.find(params[:id])
    @time_log.updatable_check()
  end

  def create
    time_log = current_user.time_logs.find_or_initialize_by(end_at: nil)
    time = Time.zone.now
    if time_log.start_at
      time_log.update(end_at: time, original_end_at: time)
      SlackBot.notify(body: "#{current_user.name}(#{current_user.account}): Start")
    else
      time_log.update(start_at: time, original_start_at: time)
      SlackBot.notify(body: "#{current_user.name}(#{current_user.account}): Stop...#{(time_log.end_at-time_log.start_at)/60.0}分")
    end
    redirect_to time_logs_path
  end

  def update
    @time_log = current_user.time_logs.find(params[:id])
    if @time_log.update_with_create_user_comment(time_log_params)
      redirect_to time_log_path(@time_log)
    else
      render 'show'
    end
  end

  private
  def time_log_params
    params.require(:time_log).permit(:end_at)
  end

  def target_month
    params[:query].try {|q|
      year = q["date(1i)"]
      month = q["date(2i)"]
      Time.zone.local(year, month) if year && month
    } || Time.zone.now
  end
end
