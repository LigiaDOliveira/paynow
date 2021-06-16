class AddStaffActiveToStaffs < ActiveRecord::Migration[6.1]
  def change
    add_column :staffs, :staff_active, :boolean, default: true
  end
end
