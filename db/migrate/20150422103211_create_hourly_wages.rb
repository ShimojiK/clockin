class CreateHourlyWages < ActiveRecord::Migration
  def change
    create_table :hourly_wages do |t|
      t.references :user, index: true, foreign_key: true
      t.datetime :start_at
      t.datetime :end_at
      t.integer :wage

      t.timestamps null: false
    end
  end
end
