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