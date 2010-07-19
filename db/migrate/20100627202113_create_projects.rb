class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.float :allotted_hours
      t.integer :client_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :projects
  end
end
