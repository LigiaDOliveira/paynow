class Company::ChargesController < ApplicationController
  before_action :set_company, only: %i[index]
  def index
    token = @company.token
    @charges = Charge.where(company_token: token)
  end
  private
  def set_company
    @company = current_staff.company
  end
end