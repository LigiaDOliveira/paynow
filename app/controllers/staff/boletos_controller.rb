class Staff::BoletosController < ActionController::Base
  before_action :authenticate_staff!
  before_action :set_payment_method, only: %i[new create edit update destroy]
  before_action :set_company, only: %i[new create]
  before_action :set_boleto, only: %i[edit update destroy]

  def new
    return redirect_to [:staff, @payment_method] if boleto_exists
    @boleto = Boleto.new
  end

  def create
    @boleto = Boleto.new(boleto_params)
    @boleto.payment_method = @payment_method
    @boleto.company = @company
    return render :new, error:'Não foi possível fazer configuração' unless @boleto.save!
    redirect_to [:staff, @payment_method], notice: 'Meio de pagamento configurado com sucesso'
  end

  def edit

  end

  def update
    return render :edit, error: 'Não foi possível atualizar configuração' unless @boleto.update(boleto_params)
    redirect_to [:staff, @payment_method], notice: 'Configuração de meio de pagamento editada com sucesso'
  end

  def destroy
    @boleto.destroy
    redirect_to [:staff, @payment_method], notice: 'Meio de pagamento desabilitado com sucesso'
  end

  private
  def boleto_params
    params
      .require(:boleto)
      .permit(:bank_code,:agency,:account)
  end

  def set_boleto
    @boleto = Boleto.find(params[:id])
  end

  def set_company
    @company = Company.find(current_staff[:company_id])
  end

  def set_payment_method
    @payment_method = PaymentMethod.find(params[:payment_method_id])
  end

  def boleto_exists
    return true if @payment_method.boletos.find{|boleto| boleto.company == @company}
    false
  end
end