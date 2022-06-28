class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.string :address_name
      t.string :address
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
