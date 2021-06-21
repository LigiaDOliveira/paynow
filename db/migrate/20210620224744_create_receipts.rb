class CreateReceipts < ActiveRecord::Migration[6.1]
  def change
    create_table :receipts do |t|
      t.string :auth_code
      t.date :due_date
      t.date :pay_date

      t.timestamps
    end
  end
end
