class ChangeCpfToString < ActiveRecord::Migration[6.1]
  def change
    change_column :customers,:cpf,:string
  end
end
