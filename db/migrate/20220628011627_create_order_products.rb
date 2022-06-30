class CreateOrderProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :order_products do |t|
      t.references :product, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.integer :order_quantity, null: false
      t.integer :order_price, null: false

      t.timestamps
    end
  end
end
