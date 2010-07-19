class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
      t.string :url_id
      t.integer :owner_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :companies
  end
end
