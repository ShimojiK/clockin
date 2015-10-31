class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :time_log, index: true, foreign_key: true
      t.text :body
      t.integer :ack_admin_id, index: true, foreign_key: true
      t.integer :status
      t.references :admin, index: true, foreign_key: true
      t.string :type, index: true

      t.timestamps null: false
    end
  end
end
