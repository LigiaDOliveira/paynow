class AddPaymentMethodAndCompanyRefsToPix < ActiveRecord::Migration[6.1]
  def change
    add_reference :pixes, :company, foreign_key: true 
    add_reference :pixes, :payment_method, foreign_key: true 
  end
end
