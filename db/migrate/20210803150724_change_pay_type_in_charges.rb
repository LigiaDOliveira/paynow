class ChangePayTypeInCharges < ActiveRecord::Migration[6.1]
  def change
    change_column :charges, :pay_type, :integer
  end
end
