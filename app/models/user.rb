class User < ActiveRecord::Base
  has_secure_password

  has_many :time_logs
  has_many :comments, through: :time_logs
  has_many :user_comments, through: :time_logs
end
