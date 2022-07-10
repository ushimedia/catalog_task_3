class CreateRegularProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :regular_products do |t|
      t.references :product, null: false, foreign_key: true
      t.references :regular, null: false, foreign_key: true
      t.integer :regular_quantity, null: false, default: 1
      t.timestamps
    end
  end
end
