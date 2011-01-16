class AddTotalToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :total, :float
  end

  def self.down
    remove_column :invoices, :total
  end
end
