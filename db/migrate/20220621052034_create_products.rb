class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :price
      t.integer :stock
      t.string :image
      t.boolean :status, default:true

      t.timestamps
    end
  end
end
