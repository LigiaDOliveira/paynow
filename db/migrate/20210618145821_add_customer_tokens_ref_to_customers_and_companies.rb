class AddCustomerTokensRefToCustomersAndCompanies < ActiveRecord::Migration[6.1]
  def change
    add_reference :customer_tokens, :customer, foreign_key: true
    add_reference :customer_tokens, :company, foreign_key: true    
  end
end
