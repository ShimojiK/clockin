class CreateTimeLogs < ActiveRecord::Migration
  def change
    create_table :time_logs do |t|
      t.references :user, index: true, foreign_key: true
      t.datetime :start_at
      t.datetime :end_at
      t.datetime :original_start_at
      t.datetime :original_end_at
      t.references :modified_by_admin

      t.timestamps null: false
    end
  end
end
