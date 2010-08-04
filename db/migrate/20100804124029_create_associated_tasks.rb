class CreateAssociatedTasks < ActiveRecord::Migration
  def self.up
    create_table :associated_tasks do |t|
      t.integer :project_id
      t.integer :task_id
      t.timestamps
    end
      add_index :associated_tasks, :project_id
      add_index :associated_tasks, :task_id
  end
  
  def self.down
      remove_index :associated_tasks, :project_id
      remove_index :associated_tasks, :task_id
    drop_table :associated_tasks
  end
end
