class User::TimeLogsController < User::Base
  def index
    @time_logs = current_user.time_logs
  end

  def new
  end

  def create
  end

  def update
  end
end