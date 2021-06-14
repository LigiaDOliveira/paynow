class Staff::PaymentMethodsController < ActionController::Base
  before_action :authenticate_staff!
  before_action :set_payment_method, only: %i[show]

  def index
    @payment_methods = PaymentMethod.all
  end

  def show
  end
  
  private
  def set_payment_method
    @payment_method = PaymentMethod.find(params[:id])
  end

end