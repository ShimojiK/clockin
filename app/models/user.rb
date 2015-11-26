class User < ActiveRecord::Base
  has_secure_password

  has_many :time_logs
  has_many :comments, through: :time_logs
  has_many :user_comments, through: :time_logs

  def newest_year
    time_logs.maximum(:start_at).try(&:year) || Time.zone.now.year
  end

  def oldest_year
    time_logs.minimum(:start_at).try(&:year) || Time.zone.now.year
  end

  def monthly_work_seconds(target_month)
    time_logs.where(start_at: target_month.all_month).inject(0) {|acc, time_log|
      acc + (time_log.end_at - time_log.start_at)
    }.floor
  end
end
