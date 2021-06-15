class AddPaymentMethodAndCompanyRefsToCreditCard < ActiveRecord::Migration[6.1]
  def change
    add_reference :credit_cards, :company, foreign_key: true 
    add_reference :credit_cards, :payment_method, foreign_key: true 
  end
end
