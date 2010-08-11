class RemoveTaskIdFromTimers < ActiveRecord::Migration
  def self.up
    remove_column :timers, :task_id
  end

  def self.down
    add_column :timers, :task_id, :integer
  end
end
