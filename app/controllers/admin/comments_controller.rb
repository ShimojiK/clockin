class Admin::CommentsController < Admin::Base
  def index
    @time_log = TimeLog.find(params[:time_log_id])
    @comments = @time_log.comments
  end

  def create
  end
end
