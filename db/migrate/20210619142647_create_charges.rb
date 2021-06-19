class CreateCharges < ActiveRecord::Migration[6.1]
  def change
    create_table :charges do |t|
      t.string :additional_params
      t.string :customer_complete_name
      t.string :customer_cpf
      t.string :company_token
      t.decimal :discount_value
      t.date :due_date
      t.decimal :original_value
      t.string :pay_type
      t.string :product_token
      t.string :status, default: 'pendente'
      t.string :token

      t.timestamps
    end
  end
end
