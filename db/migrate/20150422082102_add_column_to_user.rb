class AddColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :password_changed, :boolean
  end
end
