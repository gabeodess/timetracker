class ChangeAmountPaidDefaultForInvoices < ActiveRecord::Migration
  def self.up
    change_column_default :invoices, :amount_paid, 0
  end

  def self.down
    change_column_default :invoices, :amount_paid, nil
  end
end
