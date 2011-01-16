class AddBillingToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :billing, :string
  end

  def self.down
    remove_column :projects, :billing
  end
end
