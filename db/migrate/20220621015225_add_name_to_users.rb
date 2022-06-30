class AddNameToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string
    add_column :users, :company_address, :string, null: false
    
    add_column :users, :role, :integer, default: 0, null: false
    add_column :users, :discarded_at, :datetime, after: :deleted
    add_index :users, :discarded_at
  end
end
