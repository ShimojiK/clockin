class Comment < ActiveRecord::Base
  belongs_to :time_log
  belongs_to :ack_admin
  belongs_to :admin
end
