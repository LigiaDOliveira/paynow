class CompaniesController < ApplicationController
  before_action :authenticate_staff!, only: %i[new create show]
  before_action :authenticate_admin_paynow!, only: %i[index request_suspension]

  def index
    @companies = Company.all
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    @staff_adm = current_staff
    return render :new unless @company.save

    @company.token = generate_token
    @staff_adm.token = @company.token
    @staff_adm.admin = true
    @staff_adm.company = @company
    @staff_adm.save!
    @company.save!
    redirect_to @company
  end

  def show
    @company = Company.find(params[:id])
  end

  def reset_token
    @staff = current_staff
    @company = Company.find(params[:company_id])
    if @staff.company == @company && @staff.admin?
      set_new_token
      redirect_to @company, notice: 'Token resetado com sucesso!'
    else
      redirect_to @company, alert: 'Permissão negada'
    end
  end

  def my_staff
    @company = Company.find(params[:id])
    unless current_staff.admin? && current_staff.company == @company
      return redirect_to root_path,
                         alert: 'Permissão negada'
    end

    @staffs = @company.staffs.all
  end

  def request_suspension
    @company = Company.find(params[:id])
    @company.suspension_required = true
    @company.suspension_required_by_id = current_admin_paynow.id
    @company.save
    redirect_to companies_path, notice: 'Suspensão solicitada com sucesso'
  end

  def destroy
    @company = Company.find(params[:id])
    if @company.suspension_required? && @company.suspension_required_by_id == current_admin_paynow.id
      redirect_to companies_path, alert: 'Permissão negada'
    else
      @company.destroy
      redirect_to companies_path, notice: 'Empresa desligada'
    end
  end

  private

  def company_params
    params
      .require(:company)
      .permit(:corporate_name, :email, :cnpj, :address)
  end

  def generate_token
    charset = Array('A'..'Z') + Array('a'..'z') + Array('0'..'9')
    Array.new(20) { charset.sample }.join
  end

  def set_new_token
    @company_staff = @company.staffs
    @company.token = generate_token
    @company_staff.each do |staff|
      staff.token = @company.token
      staff.save!
    end
    @company.save!
  end
end
