class TimeLog < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :user_comments
  has_many :admin_comments

  validate :not_inversion

  def not_inversion
    errors.add(:base, "Must not inversion time") if end_at && start_at >= end_at
  end

  # fixme まだ終了打刻されていないとエラーになる
  def user_updatable?
    Time.now < original_end_at + 1.hour
  end

  def shorten?(param)
    end_at > Time.zone.local(*param.values)
  end

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
