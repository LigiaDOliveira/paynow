class RemoveTypeFromPaymentMethods < ActiveRecord::Migration[6.1]
  def change
    remove_column :payment_methods, :type, :string
  end
end
