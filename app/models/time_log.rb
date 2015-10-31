class TimeLog < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :user_comments
  has_many :admin_comments

  validate :not_inversion

  def not_inversion
    errors.add(:base, "Must not inversion time") if end_at && start_at >= end_at
  end

  def user_updatable?
    original_end_at && non_last?.! && time_up?.!
  end

  def updatable_check(params = nil)
    if params && lengthen?(params)
      errors.add(:base, "延長はできません")
    elsif original_end_at.!
      errors.add(:base, "まだ終了していません")
    elsif non_last?
      errors.add(:base, "変更できるのは最新の打刻だけです")
    elsif time_up?
      errors.add(:base, "変更ができるのは打刻後60分以内です")
    end
  end

  def update_with_create_user_comment(params)
    old_end = self.end_at
    updatable_check(params)
    unless errors.any?
      if update(params)
        user_comments.create(body: "終了時刻を:#{old_end} から #{end_at}に変更しました")
      end
    end
  end

  def update_with_create_admin_comment(params, old_end, admin)
    update_with_info(params) do
      admin_comments.create(admin: admin, body: "#{admin.account}が終了時刻を:#{old_end} から #{end_at}に変更しました")
    end
  end

  private
  def lengthen?(param)
    end_at < Time.zone.local(param["end_at(1i)"], param["end_at(2i)"], param["end_at(3i)"], param["end_at(4i)"], param["end_at(5i)"])
  end

  def non_last?
    self != self.user.time_logs.last
  end

  def time_up?
    Time.now > original_end_at + 1.hour
  end

  def update_with_info(params)
    if update(params)
      if yield
        { notice: "更新に成功しました" }
      else
        { notice: "コメントの投稿に失敗しました(時刻の変更には問題ありません)" }
      end
    else
      { alert: "更新に失敗しました" }
    end
  end
end
