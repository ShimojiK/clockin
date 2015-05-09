class Admin::CommentsController < Admin::Base
  def index
    @comments = TimeLog.find(params[:time_log_id]).comments
  end

  def create
  end
end
