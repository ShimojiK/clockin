class Admin < ActiveRecord::Base
  has_secure_password

  has_many :admin_comment
end
