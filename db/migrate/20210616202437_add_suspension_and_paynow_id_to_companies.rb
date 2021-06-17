class AddSuspensionAndPaynowIdToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :suspension_required, :boolean, default: false
    add_column :companies, :suspension_required_by_id, :integer, default: nil
  end
end
