class Staff::PixesController < ActionController::Base
  before_action :authenticate_staff!
  before_action :set_payment_method, only: %i[new create edit update destroy]
  before_action :set_company, only: %i[new create]
  before_action :set_pix, only: %i[edit update destroy]

  def new
    return redirect_to [:staff, @payment_method] if pix_exists
    @pix = Pix.new
  end

  def create
    @pix = Pix.new(pix_params)
    @pix.payment_method = @payment_method
    @pix.company = @company
    return render :new, error:'Não foi possível fazer configuração' unless @pix.save!
    redirect_to [:staff, @payment_method], notice: 'Meio de pagamento configurado com sucesso'
  end

  def edit

  end

  def update
    return render :edit, error: 'Não foi possível atualizar configuração' unless @pix.update(pix_params)
    redirect_to [:staff, @payment_method], notice: 'Configuração de meio de pagamento editada com sucesso'
  end

  def destroy
    @pix.destroy
    redirect_to [:staff, @payment_method], notice: 'Meio de pagamento desabilitado com sucesso'
  end

  private
  def pix_params
    params
      .require(:pix)
      .permit(:pix_key, :bank_code)
  end

  def set_pix
    @pix = Pix.find(params[:id])
  end

  def set_company
    @company = Company.find(current_staff[:company_id])
  end

  def set_payment_method
    @payment_method = PaymentMethod.find(params[:payment_method_id])
  end

  def pix_exists
    return true if @payment_method.pixes.find{|pix| pix.company == @company}
    false
  end
end