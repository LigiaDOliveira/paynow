class AddTokenToStaff < ActiveRecord::Migration[6.1]
  def change
    add_column :staffs, :token, :string
  end
end
