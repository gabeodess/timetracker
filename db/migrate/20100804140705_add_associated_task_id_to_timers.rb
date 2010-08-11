class AddAssociatedTaskIdToTimers < ActiveRecord::Migration
  def self.up
    add_column :timers, :associated_task_id, :integer
    add_index :timers, :associated_task_id
  end

  def self.down
    remove_index :timers, :associated_task_id
    remove_column :timers, :associated_task_id
  end
end
