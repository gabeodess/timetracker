class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.integer :client_id
      t.text :info
      t.timestamps
    end
    add_index :invoices, :client_id
  end
  
  def self.down
    remove_index :invoices, :client_id
    drop_table :invoices
  end
end
