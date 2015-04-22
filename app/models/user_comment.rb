class UserComment < Comment
  belongs_to :ack_admin, class: :admin

  validates_presence_of :status
end
