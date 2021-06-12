class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.string :email
      t.integer :cnpj
      t.string :corporate_name
      t.string :address

      t.timestamps
    end
  end
end
