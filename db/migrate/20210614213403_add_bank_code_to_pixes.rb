class AddBankCodeToPixes < ActiveRecord::Migration[6.1]
  def change
    add_column :pixes, :bank_code, :integer
  end
end
