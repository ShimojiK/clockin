class Comment < ActiveRecord::Base
  belongs_to :time_log

  validates_presence_of :body
  validates_presence_of :type

  def state
    case status
    when 0 then "未承認"
    when 1 then "承認"
    else "error"
    end
  end
end
