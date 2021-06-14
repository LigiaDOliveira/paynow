class AddPaymentMethodAndCompanyRefsToBoleto < ActiveRecord::Migration[6.1]
  def change
    add_reference :boletos, :company, foreign_key: true 
    add_reference :boletos, :payment_method, foreign_key: true 
  end
end
