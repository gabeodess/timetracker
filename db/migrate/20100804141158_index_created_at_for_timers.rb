class IndexCreatedAtForTimers < ActiveRecord::Migration
  def self.up
    add_index :timers, :created_at
  end

  def self.down
    remove_index :timers, :created_at
  end
end
