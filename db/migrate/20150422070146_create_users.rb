class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.text :desc
      t.string :account
      t.string :password_digest

      t.timestamps null: false
    end
  end
end
