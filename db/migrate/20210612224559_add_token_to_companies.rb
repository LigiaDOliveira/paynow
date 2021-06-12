class AddTokenToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :token, :string
  end
end
