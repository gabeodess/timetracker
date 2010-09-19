class CreateExpenses < ActiveRecord::Migration
  def self.up
    create_table :expenses do |t|
      t.string :name
      t.decimal :cost, :default => 0
      t.integer :invoice_id
      t.integer :project_id
      t.timestamps
    end
    add_index :expenses, :invoice_id
    add_index :expenses, :project_id
  end
  
  def self.down
    remove_index :expenses, :invoice_id
    remove_index :expenses, :project_id
    drop_table :expenses
  end
end
