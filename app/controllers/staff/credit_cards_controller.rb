class Staff::CreditCardsController < ApplicationController
  before_action :authenticate_staff!
  before_action :set_payment_method, only: %i[new create edit update destroy]
  before_action :set_company, only: %i[new create]
  before_action :set_credit_card, only: %i[edit update destroy]

  def new
    return redirect_to [:staff, @payment_method] if credit_card_exists

    @credit_card = CreditCard.new
  end

  def create
    @credit_card = CreditCard.new(credit_card_params)
    @credit_card.payment_method = @payment_method
    @credit_card.company = @company
    return render :new, error: 'Não foi possível fazer configuração' unless @credit_card.save!

    redirect_to [:staff, @payment_method], notice: 'Meio de pagamento configurado com sucesso'
  end

  def edit; end

  def update
    unless @credit_card.update(credit_card_params)
      return render :edit,
                    error: 'Não foi possível atualizar configuração'
    end

    redirect_to [:staff, @payment_method], notice: 'Configuração de meio de pagamento editada com sucesso'
  end

  def destroy
    @credit_card.destroy
    redirect_to [:staff, @payment_method], notice: 'Meio de pagamento desabilitado com sucesso'
  end

  private

  def credit_card_params
    params
      .require(:credit_card)
      .permit(:cc_code)
  end

  def set_credit_card
    @credit_card = CreditCard.find(params[:id])
  end

  def set_company
    @company = Company.find(current_staff[:company_id])
  end

  def set_payment_method
    @payment_method = PaymentMethod.find(params[:payment_method_id])
  end

  def credit_card_exists
    return true if @payment_method.credit_cards.find { |credit_card| credit_card.company == @company }

    false
  end
end
