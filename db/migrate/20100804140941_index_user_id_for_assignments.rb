class IndexUserIdForAssignments < ActiveRecord::Migration
  def self.up
    add_index :assignments, :user_id
  end

  def self.down
    remove_index :assignments, :user_id
  end
end
