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
end
