class Staff::BoletosController < ActionController::Base
  before_action :authenticate_staff!
  before_action :set_payment_method, only: %i[new create]
  before_action :set_company, only: %i[create]

  def new
    @boleto = Boleto.new
  end

  def create
    @boleto = @payment_method.boletos.new(boleto_params)
    @boleto.company = @company
    @boleto.save!
    redirect_to [:staff, @payment_method]
  end

  private
  def boleto_params
    params
      .require(:boleto)
      .permit(:bank_code,:agency,:account)
  end

  def set_company
    @company = Company.find(current_staff[:company_id])
  end

  def set_payment_method
    @payment_method = PaymentMethod.find(params[:payment_method_id])
  end
end