class CreateBoletos < ActiveRecord::Migration[6.1]
  def change
    create_table :boletos do |t|
      t.integer :bank_code
      t.integer :agency
      t.integer :account

      t.timestamps
    end
  end
end
