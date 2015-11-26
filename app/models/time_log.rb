class TimeLog < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :user_comments
  has_many :admin_comments

  validate :not_inversion

  def not_inversion
    errors.add(:base, "終了時刻が開始時刻より前です") if end_at && start_at >= end_at
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

  def update_with_create_admin_comment(params, admin)
    old_end = self.end_at
    if update(params)
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
    Time.zone.now > original_end_at + 1.hour
  end
end
