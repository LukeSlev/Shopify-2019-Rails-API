class CreateLineItems < ActiveRecord::Migration[5.2]
  def change
    create_table :line_items do |t|
      t.string :name
      t.references :product, foreign_key: true
      t.references :order, foreign_key: true
      t.decimal :cost
      t.integer :quantity
      t.decimal :total

      t.timestamps
    end
  end
end
