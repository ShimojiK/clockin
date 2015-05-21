class UserComment < Comment
  has_one :user, through: :time_log
  belongs_to :ack_admin, class_name: "Admin"

  validates_presence_of :status
end
