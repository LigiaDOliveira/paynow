class CompaniesController < ApplicationController
  before_action :authenticate_staff!
  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    @staff_adm = current_staff
    if @company.save
      @company.token = generate_token
      @staff_adm.token = @company.token
      @staff_adm.admin = true
      @staff_adm.company = @company
      @staff_adm.save!
      @company.save!
      redirect_to @company
    else
      render :new
    end
  end

  def show
    @company = Company.find(params[:id])
  end

  def reset_token
    @staff = current_staff
    @company = Company.find(params[:company_id])
    if @staff.company == @company && @staff.admin?
      @company_staff = @company.staffs
      @company.token = generate_token
      @company_staff.each do |staff|
        staff.token = @company.token
        staff.save!
      end
      @company.save!
      redirect_to @company, notice: 'Token resetado com sucesso!'
    else
      redirect_to @company, error: 'Permissão negada'
    end 
  end

  def my_staff
    @company = Company.find(params[:id])
    return redirect_to root_path, alert: 'Permissão negada' unless current_staff.admin? && current_staff.company == @company
    @staffs = @company.staffs.all
  end

  private
  def company_params
    params
      .require(:company)
      .permit(:corporate_name,:email,:cnpj,:address)
  end

  def generate_token
    charset = Array('A'..'Z') + Array('a'..'z') + Array('0'..'9')
    Array.new(20) {charset.sample}.join
  end
end