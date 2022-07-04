class CreateRegulars < ActiveRecord::Migration[6.0]
  def change
    create_table :regulars do |t|
      t.references :product, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :regular_quantity, null: false, default: 1
      t.integer :regular_number, default: 1

      t.timestamps
    end
  end
end
