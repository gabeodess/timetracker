class RemoveProjectIdFromTasks < ActiveRecord::Migration
  def self.up
    remove_column :tasks, :project_id
  end

  def self.down
    add_column :tasks, :project_id, :integer
  end
end
