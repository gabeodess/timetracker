class AddDefaultToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :default, :boolean, :default => false
  end

  def self.down
    remove_column :tasks, :default
  end
end
