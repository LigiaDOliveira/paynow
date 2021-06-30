class PaymentMethodsPayTypeFromStringToInteger < ActiveRecord::Migration[6.1]
  def change
    change_column :payment_methods, :pay_type, :integer
  end
end
