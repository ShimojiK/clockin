class ChangeColumnToUser < ActiveRecord::Migration
  def change
    change_column :users, :password_changed, :boolean, default: false
  end
end
