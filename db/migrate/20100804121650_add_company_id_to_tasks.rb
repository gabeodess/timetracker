class AddCompanyIdToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :company_id, :integer
    add_index :tasks, :company_id
  end

  def self.down
    remove_index :tasks, :company_id
    remove_column :tasks, :company_id
  end
end
