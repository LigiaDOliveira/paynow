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
    return permission_denied(@company) unless @staff&.allowed_on? @company

    set_new_token
    redirect_to @company, notice: 'Token resetado com sucesso!'
  end

  def my_staff
    @company = Company.find(params[:id])
    return permission_denied(root_path) unless current_staff&.allowed_on? @company

    @staffs = @company.staffs.all
  end

  def request_suspension
    @company = Company.find(params[:id])
    update_suspension_required
    redirect_to companies_path, notice: 'Suspensão solicitada com sucesso'
  end

  def destroy
    @company = Company.find(params[:id])
    permission_denied(companies_path) unless @company&.destroy_allowed? current_admin_paynow

    @company.destroy
    redirect_to companies_path, notice: 'Empresa desligada'
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

  def permission_denied(path)
    redirect_to path, alert: 'Permissão negada'
  end

  def set_new_token
    @company.token = generate_token
    @company.staffs.each { |staff| staff.update! token: @company.token }
    @company.save!
  end

  def update_suspension_required_hash
    {
      suspension_required: true,
      suspension_required_by_id: current_admin_paynow.id
    }
  end

  def update_suspension_required
    @company.update!(**update_suspension_required_hash)
  end
end
