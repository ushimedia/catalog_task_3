class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.integer :price, null: false
      t.integer :stock, null: false
      t.boolean :status, default: true, null: false
      t.string :image
      t.references :user, null: false, foreign_key: true
      t.datetime :discarded_at, after: :deleted


      t.timestamps
    end
  end
end
