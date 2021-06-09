class RenameAdminPaynowsToAdminsPaynow < ActiveRecord::Migration[6.1]
  def change
    rename_table :admin_paynows, :admins_paynow
  end
end
