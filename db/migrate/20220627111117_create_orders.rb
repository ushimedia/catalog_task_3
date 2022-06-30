class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.integer	:total_price, null: false
      t.integer	:status, default: 0, null: false
      t.references :user, null: false, foreign_key: true
      t.datetime :discarded_at, after: :deleted
      t.timestamps
    end
  end
end
