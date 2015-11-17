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

  # get both year by once
  def newest_and_oldest_year
    hash = ActiveRecord::Base.connection.execute(<<-SQL).first
      SELECT MAX(start_at) AS max, MIN(start_at) AS min FROM time_logs WHERE user_id = #{self.id};
    SQL
    hash.try do
      {
        max: hash["max"].to_date.year,
        min: hash["min"].to_date.year
      }
    end || Time.zone.now.year
  end
end
