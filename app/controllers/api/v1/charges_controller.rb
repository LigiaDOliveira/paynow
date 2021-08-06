module Api
  module V1
    class ChargesController < Api::V1::ApiController
      before_action :set_product, :set_company, only: %i[create]

      def create
        @charge = Charge.new(charge_params)
        @charge.original_value = @product.price
        @charge.discount_value = @product.price - @product.price * @product.sale_discount / 100
        additional_params_manager
        @charge.additional_params = @additional_params
        @charge.save!
        render json: @charge
          .as_json(except: %i[id created_at updated_at]), status: :created
      end

      def search
        @charges = Charge.all
        @charges = @charges.where(due_date: params[:due_date]) if params.keys.include? 'due_date'
        @charges = @charges.where(pay_type: params[:pay_type]) if params.keys.include? 'pay_type'
        render json: @charges.as_json(except: %i[id created_at updated_at]), status: :ok
      end

      private

      def set_product
        @product = Product.find_by!(token: params[:charge][:product_token])
      end

      def set_company
        @company = Company.find_by!(token: params[:charge][:company_token])
      end

      def additional_params_manager
        if @charge.boleto? && params[:additional_params].present?
          additional_params_boleto
        elsif @charge.credit_card? && params[:additional_params].present?
          additional_params_credit_card
        elsif @charge.pix?
          @additional_params = 'Nenhum'
        end
      end

      def additional_params_boleto
        address = params.require(:additional_params).permit(:address)
        @additional_params = "Endereço: #{address[:address]}"
      end

      def additional_params_credit_card
        cc_number = params.require(:additional_params).permit(:cc_number)
        cc_name = params.require(:additional_params).permit(:cc_name)
        cc_cvv = params.require(:additional_params).permit(:cc_cvv)
        @additional_params =
          "Nº do cartão: #{cc_number[:cc_number]}\n"\
          "Nome no cartão: #{cc_name[:cc_name]}\n"\
          "Código de segurança: #{cc_cvv[:cc_cvv]}"
      end

      def charge_params
        params
          .require(:charge)
          .permit(:company_token, :product_token, :customer_complete_name, :customer_cpf, :pay_type, :due_date)
      end
    end
  end
end
