class StaffController < ApplicationController
  before_action :set_staff_to_block, only: %i[block_staff]

  def block_staff
    if validate_admin_staff
      @staff_to_block.staff_active = false
      @staff_to_block.save
      redirect_to my_staff_company_path(current_staff.company)
    else
      flash[:alert] = 'Você não pode bloquear este funcionário'
    end
  end

  def validate_admin_staff
    current_staff.admin? && current_staff.company == @staff_to_block.company
  end

  def set_staff_to_block
    @staff_to_block = Staff.find(params[:format])
  end

end