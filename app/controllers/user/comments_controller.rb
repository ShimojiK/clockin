class User::CommentsController < User::Base
  def create
    comment = current_user.time_logs.find(params[:time_log_id]).user_comments.new(comment_params)
    redirect_to time_log_comments_path(params[:time_log_id]), alert: (comment.save ? nil : "コメントの投稿に失敗しました")
  end

  private
  def comment_params
    params.require(:user_comment).permit(:body)
  end
end
