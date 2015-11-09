class Admin::CommentsController < Admin::Base
  def create
    comment = TimeLog.find(params[:time_log_id]).admin_comments.new(comment_params.merge(admin_id: current_admin.id))
    redirect_to admin_time_log_path(comment.time_log), alert: (comment.save ? nil : "コメントの投稿に失敗しました")
  end

  def update
    UserComment.find(params[:id]).update(status_params.merge(ack_admin_id: current_admin.id))
    render nothing: true
  end

  private
  def comment_params
    params.require(:admin_comment).permit(:body)
  end

  def status_params
    params.require(:admin_comment).permit(:status)
  end
end
