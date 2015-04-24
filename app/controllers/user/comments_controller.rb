class User::CommentsController < User::Base
  def index
    # current_user.comments.where(time_log_id: params[:time_log_id])
    @comments = current_user.time_logs.find(params[:time_log_id]).comments
  end
end
