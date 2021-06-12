class ChangeCnpjInCompaniesAgain < ActiveRecord::Migration[6.1]
  def change
    change_column :companies,:cnpj,:string
  end
end
