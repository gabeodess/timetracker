class AddInvoiceIdToTimers < ActiveRecord::Migration
  def self.up
    add_column :timers, :invoice_id, :integer
  end

  def self.down
    remove_column :timers, :invoice_id
  end
end
