class AddBillingRateToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :billing_rate, :float
  end

  def self.down
    remove_column :projects, :billing_rate
  end
end
