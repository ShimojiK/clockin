class Admin < ActiveRecord::Base
  has_secure_password

  has_many :comments
  has_many :admin_comments
end
