class AddHistoryToCharges < ActiveRecord::Migration[6.1]
  def change
    add_column :charges, :history, :string
  end
end
