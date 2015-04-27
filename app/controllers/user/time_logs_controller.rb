class User::TimeLogsController < User::Base
  def index
    @time_logs = current_user.time_logs
  end

  def new
    @time_log = current_user.time_logs.find_or_initialize_by(end_at: nil)
  end

  def create
    time_log = current_user.time_logs.find_or_initialize_by(end_at: nil)
    if time_log.start_at
      time_log.update(end_at: Time.now)
    else
      time_log.start_at = Time.now
      time_log.save
    end
    redirect_to :back
  end

  def update
  end
end
