class Comment < ActiveRecord::Base
  belongs_to :time_log

  validates_presence_of :body
  validates_presence_of :type
end
