class CompaniesController < ApplicationController
  before_action :authenticate_staff!
  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    if @company.save
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
end