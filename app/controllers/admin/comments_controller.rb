class Admin::CommentsController < Admin::Base
  def index
    @time_log = TimeLog.find(params[:time_log_id])
    @comments = @time_log.comments
    @new_comment = @time_log.admin_comments.new # formでTimelog.newも可
  end

  def create
    comment = TimeLog.find(params[:time_log_id]).admin_comments.new(comment_params.merge(admin_id: current_admin.id))
    redirect_to :back, alert: (comment.save ? nil : "コメントの投稿に失敗しました")
  end

  private
  def comment_params
    params.require(:admin_comment).permit(:body)
  end
end
