class AddEmailToCompanyBasedRoles < ActiveRecord::Migration
  def self.up
    add_column :company_based_roles, :email, :string
    CompanyBasedRole.all.each do |cbr|
      cbr.update_attribute(:email, cbr.user_email)
    end
    add_index :company_based_roles, :email
  end

  def self.down
    remove_index :company_based_roles, :email
    remove_column :company_based_roles, :email
  end
end