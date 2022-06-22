class AddNameToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string
    add_column :users, :role, :integer, default: 0, null: false
    add_reference :users, :company, foreign_key: true
  end
end
