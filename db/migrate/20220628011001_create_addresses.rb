class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
