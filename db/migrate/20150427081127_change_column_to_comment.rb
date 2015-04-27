class ChangeColumnToComment < ActiveRecord::Migration
  def change
    change_column :comments, :status, :integer, default: 0
  end
end
