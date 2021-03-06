module Api
  module V1
    class CustomersController < Api::V1::ApiController
      def index
        @customers = Customer.all
        render json: @customers
          .as_json(except: %i[id created_at updated_at])
      end

      def create
        @customer = Customer.find_or_create_by!(customer_params)
        return render_prec_failed unless @customer

        set_company_and_token
        render json: @token
          .as_json(
            only: %i[token],
            include: { customer: { only: %i[complete_name cpf] }, company: { only: :token } }
          ), status: :created
      end

      private

      def customer_params
        params
          .require(:customer)
          .permit(:complete_name, :cpf)
      end

      def render_prec_failed
        render status: :precondition_failed, json: { errors: 'parâmetros inválidos' }
      end

      def set_company_and_token
        @company = Company.find_by(token: params[:token])
        @token = CustomerToken.create!(customer: @customer, company: @company)
      end
    end
  end
end
