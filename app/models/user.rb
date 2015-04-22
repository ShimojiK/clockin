class User < ActiveRecord::Base
  has_secure_password

  has_many :time_logs
end
