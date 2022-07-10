class CreateRegulars < ActiveRecord::Migration[6.0]
  def change
    create_table :regulars do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :regular_number, default: 1, null: false, foreign_key: true

      t.timestamps
    end
  end
end
