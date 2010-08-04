class RemoveTaskIdFromAssignments < ActiveRecord::Migration
  def self.up
    remove_column :assignments, :task_id
  end

  def self.down
    add_column :assignments, :task_id, :integer
  end
end
