class CreateCompanyBasedRoles < ActiveRecord::Migration
  def self.up
    create_table :company_based_roles do |t|
      t.string :name
      t.integer :company_id
      t.integer :user_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :company_based_roles
  end
end
