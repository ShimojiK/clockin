class User::CommentsController < User::Base
  def index
    @time_log = current_user.time_logs.find(params[:time_log_id])
    @comments = @time_log.comments
    @new_comment = @time_log.user_comments.new
  end

  def create
    comment = current_user.time_logs.find(params[:time_log_id]).user_comments.new(comment_params)
    redirect_to time_log_comments_path(params[:time_log_id]), alert: (comment.save ? nil : "コメントの投稿に失敗しました")
  end

  private
  def comment_params
    params.require(:user_comment).permit(:body)
  end
end
