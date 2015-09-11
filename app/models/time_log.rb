class TimeLog < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :user_comments
  has_many :admin_comments

  validate :not_inversion

  def not_inversion
    errors.add(:base, "Must not inversion time") if end_at && start_at >= end_at
  end

  def shorten?(param)
    end_at > Time.zone.local(param["end_at(1i)"], param["end_at(2i)"], param["end_at(3i)"], param["end_at(4i)"], param["end_at(5i)"])
  end

  def user_updatable_status
    if original_end_at
      if self == self.user.time_logs.last
        if Time.now < original_end_at + 1.hour
          :ok
        else
          :time_over
        end
      else
        :non_target
      end
    else
      :uncomplete
    end
  end

  def user_updatable?
    user_updatable_status == :ok
  end

  #fixme uncool
  # should not hard-code notice, alert
  def update_with_create_user_comment(params, old_end)
    if update(params)
      if user_comments.create(body: "終了時刻を:#{old_end} から #{end_at}に変更しました")
        { alert: nil }
      else
        { notice: "コメントの投稿に失敗しました(時刻の変更には問題ありません)" }
      end
    else
      { alert: "更新に失敗しました" }
    end
  end

  def update_with_create_admin_comment(params, old_end, admin)
    if update(params)
      if admin_comments.create(admin: admin, body: "#{admin.account}が終了時刻を:#{old_end} から #{end_at}に変更しました")
        { alert: nil }
      else
        { notice: "コメントの投稿に失敗しました(時刻の変更には問題ありません)" }
      end
    else
      { alert: "更新に失敗しました" }
    end
  end
end
