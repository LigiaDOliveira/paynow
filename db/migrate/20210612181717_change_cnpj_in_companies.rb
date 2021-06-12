class ChangeCnpjInCompanies < ActiveRecord::Migration[6.1]
  def change
    change_column :companies,:cnpj,:text
  end
end
