class AdminComment < Comment
  belongs_to :admin

  validates_presence_of :admin_id
end
