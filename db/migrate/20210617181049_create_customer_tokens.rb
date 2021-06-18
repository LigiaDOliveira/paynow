class CreateCustomerTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :customer_tokens do |t|
      t.string :token
      
      t.timestamps
    end
  end
end
