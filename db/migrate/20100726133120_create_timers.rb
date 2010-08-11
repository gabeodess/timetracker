class CreateTimers < ActiveRecord::Migration
  def self.up
    create_table :timers do |t|
      t.text :notes
      t.integer :total_time
      t.datetime :timer_started_at
      t.integer :task_id
      t.integer :user_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :timers
  end
end
