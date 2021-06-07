class AddPayTypeToPaymentMethods < ActiveRecord::Migration[6.1]
  def change
    add_column :payment_methods, :pay_type, :string
  end
end
