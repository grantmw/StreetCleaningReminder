class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.integer :user_id
  		t.integer :hour
      t.integer :duration
  		t.string :day
  		t.string :frequency 

    	t.timestamps null: false
    end
  end
end
