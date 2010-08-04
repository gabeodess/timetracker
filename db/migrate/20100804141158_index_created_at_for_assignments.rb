class IndexCreatedAtForAssignments < ActiveRecord::Migration
  def self.up
    add_index :assignments, :created_at
  end

  def self.down
    remove_index :assignments, :created_at
  end
end
