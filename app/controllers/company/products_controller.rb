class Company::ProductsController < ApplicationController
  before_action :authenticate_staff!
  before_action :set_company, only: %i[index]
  def index
    @products = Product.all
  end

  private
  def set_company
    @company = current_staff.company
  end
end