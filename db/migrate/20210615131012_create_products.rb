class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.decimal :sale_discount, default: 0
      t.string :token

      t.timestamps
    end
  end
end
