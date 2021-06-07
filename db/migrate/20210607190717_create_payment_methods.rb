class CreatePaymentMethods < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_methods do |t|
      t.string :name
      t.decimal :charging_fee
      t.decimal :maximum_charge
      t.string :type

      t.timestamps
    end
  end
end
