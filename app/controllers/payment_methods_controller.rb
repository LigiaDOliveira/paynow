class PaymentMethodsController < ApplicationController
  before_action :authenticate_admin_paynow!
  def index
    @payment_methods = PaymentMethod.all
  end

  def show
    @payment_method = PaymentMethod.find(params[:id])
  end

  def new
    @payment_method = PaymentMethod.new
  end

  def create
    @payment_method = PaymentMethod.new(payment_method_params)
    return render :new unless @payment_method.save

    redirect_to payment_methods_path
  end

  def edit
    @payment_method = PaymentMethod.find(params[:id])
  end

  def update
    @payment_method = PaymentMethod.find(params[:id])
    return render :edit unless @payment_method.update(payment_method_params)

    redirect_to @payment_method, notice: 'Meio de pagamento editado com sucesso'
  end

  def destroy
    @payment_method = PaymentMethod.find(params[:id])
    @payment_method.destroy
    redirect_to payment_methods_path, notice: 'Meio de pagamento apagado com sucesso'
  end

  private

  def payment_method_params
    params
      .require(:payment_method)
      .permit(:name, :charging_fee, :maximum_charge, :pay_type, :icon)
  end
end
