class Company::ProductsController < ApplicationController
  before_action :authenticate_staff!
  before_action :set_company, only: %i[index show new create]
  before_action :set_product, only: %i[show]
  def index
    @products = @company.products.all
  end

  def show

  end

  def new
    @product = @company.products.new
  end

  def create
    @product = @company.products.new(product_params)
    return render :new, error: 'Erros foram encontrados' unless @product.save
    redirect_to [@company,@product], notice: 'Produto cadastrado com sucesso'
  end

  private
  def set_company
    @company = current_staff.company
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params
      .require(:product)
      .permit(:name,:price,:sale_discount)
  end
end