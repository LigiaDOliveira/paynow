class Api::V1::ChargesController < Api::V1::ApiController
  before_action :set_product, :set_company, only: %i[create]
  
  def create
    @charge = Charge.new(charge_params)
    @charge.original_value = @product.price
    @charge.discount_value = @product.price - @product.price*@product.sale_discount/100
    additional_params_manager
    @charge.additional_params = @additional_params
    @charge.save!
    render json: @charge
      .as_json(except: %i[id created_at updated_at]), status: :created
  end

  private
  def set_product
    @product = Product.find_by!(token: params[:charge][:product_token])
  end

  def set_company
    @company = Company.find_by!(token: params[:charge][:company_token])
  end

  def additional_params_manager
    if @charge.pay_type.eql?('boleto') && !params[:additional_params].nil?
      address = params.require(:additional_params).permit(:address)
      @additional_params = "Endereço: #{address[:address]}"
    elsif @charge.pay_type.eql?('cartão de crédito') && !params[:additional_params].nil?
      cc_number = params.require(:additional_params).permit(:cc_number)
      cc_name = params.require(:additional_params).permit(:cc_name)
      cc_cvv = params.require(:additional_params).permit(:cc_cvv)
      @additional_params = "Nº do cartão: #{cc_number[:cc_number]}\n"\
                            "Nome no cartão: #{cc_name[:cc_name]}\n"\
                            "Código de segurança: #{cc_cvv[:cc_cvv]}"
    elsif @charge.pay_type.eql?('PIX')
      @additional_params = "Nenhum"      
    end
  end

  def charge_params
    params
      .require(:charge)
      .permit(:company_token, :product_token, :customer_complete_name, :customer_cpf, :pay_type, :due_date)
  end
end