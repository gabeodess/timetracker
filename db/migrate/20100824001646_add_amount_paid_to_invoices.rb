class AddAmountPaidToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :amount_paid, :float
  end

  def self.down
    remove_column :invoices, :amount_paid
  end
end
