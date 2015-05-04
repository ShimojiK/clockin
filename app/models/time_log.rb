class TimeLog < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :user_comments

  validate :not_inversion

  def not_inversion
    errors.add(:base, "Must not inversion time") if end_at && start_at >= end_at
  end

  def create_update_comment(old_end)
    user_comments.create(body: "終了時刻を:#{old_end} から #{end_at}に変更しました")
  end

  def user_updatable?
    Time.now < original_end_at + 1.hour
  end

  def shorten?(param)
    end_at > Time.zone.local(*param.values)
  end
end
