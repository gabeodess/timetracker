class AddAssociatedTaskIdToAssignments < ActiveRecord::Migration
  def self.up
    add_column :assignments, :associated_task_id, :integer
    add_index :assignments, :associated_task_id
  end

  def self.down
    remove_index :assignments, :associated_task_id
    remove_column :assignments, :associated_task_id
  end
end
