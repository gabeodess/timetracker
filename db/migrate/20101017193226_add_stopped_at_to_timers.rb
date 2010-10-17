class AddStoppedAtToTimers < ActiveRecord::Migration
  def self.up
    add_column :timers, :stopped_at, :datetime
  end

  def self.down
    remove_column :timers, :stopped_at
  end
end
