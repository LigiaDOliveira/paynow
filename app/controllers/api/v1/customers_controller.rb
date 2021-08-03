module Api
  module V1
    class CustomersController < Api::V1::ApiController
      def index
        @customers = Customer.all
        render json: @customers
          .as_json(except: %i[id created_at updated_at])
      end

      def create
        if @customer = Customer.find_or_create_by!(customer_params)
          @company = Company.find_by(token: params[:token])
          @token = CustomerToken.create!(customer: @customer, company: @company)
          render json: @token
            .as_json(
              only: %i[token],
              include: { customer: { only: %i[complete_name cpf] }, company: { only: :token } }
            ), status: :created
        else
          render status: :precondition_failed, json: { errors: 'parâmetros inválidos' }
        end
      end

      private

      def customer_params
        params
          .require(:customer)
          .permit(:complete_name, :cpf)
      end
    end
  end
end
