class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :name
      t.string :address
      t.integer	 :total_price
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
