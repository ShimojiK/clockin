class User < ActiveRecord::Base
  has_secure_password

  has_many :time_logs
  has_many :comments, through: :time_logs
  has_many :user_comments, through: :time_logs

  def newest_year
    time_logs.maximum(:original_start_at).year
  end

  def oldest_year
    time_logs.minimum(:original_start_at).year
  end

  # get both year by once
  def newest_and_oldest_year
    hash = ActiveRecord::Base.connection.execute(<<-SQL).first
      SELECT MAX(original_start_at) AS max, MIN(original_start_at) AS min FROM time_logs WHERE user_id = #{self.id};
    SQL
    {
      max: hash["max"].to_date.year,
      min: hash["min"].to_date.year
    }
  end
end
