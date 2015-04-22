class Comment < ActiveRecord::Base
  belongs_to :time_log
  has_one :user, through: :time_log

  validates_presence_of :body
  validates_presence_of :type
end
