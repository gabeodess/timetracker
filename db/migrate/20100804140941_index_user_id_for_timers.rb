class IndexUserIdForTimers < ActiveRecord::Migration
  def self.up
    add_index :timers, :user_id
  end

  def self.down
    remove_index :timers, :user_id
  end
end
