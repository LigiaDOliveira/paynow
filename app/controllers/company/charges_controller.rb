class Company::ChargesController < ApplicationController
  before_action :set_company, only: %i[index]
  def index
    token = @company.token
    @charges = Charge.where(company_token: token)
  end

  def update
    @charge = Charge.find(params[:id])
    @charge.status = params[:charge][:status]
    @charge.history = if @charge.history.nil?
                        params_history
                      else
                        "#{@charge.history}\n\n#{params_history}"
                      end
    @charge.save
    redirect_to company_charges_path
  end

  def new_reject
    @charge = Charge.find(params[:charge_id])
  end

  def new_approve
    @charge = Charge.find(params[:charge_id])
    @charge.status = 'aprovada'
    @charge
  end

  private

  def set_company
    @company = current_staff.company
  end

  def params_history
    if params[:charge][:status].eql?('aprovada')
      "Aprovada em #{params[:charge][:approved_date]}"
    else
      "Data da tentativa de pagamento: #{params[:charge][:denied_date]}\n"\
        "Código de retorno: #{params[:charge][:return_code]}"
    end
  end
end
