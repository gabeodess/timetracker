class CreateAssignedProjects < ActiveRecord::Migration
  def self.up
    create_table :assigned_projects do |t|
      t.integer :user_id
      t.integer :project_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :assigned_projects
  end
end
