class Api::V1::CustomersController < Api::V1::ApiController
  def index
    @customers = Customer.all
    render json: @customers
      .as_json(except: [:id,:created_at,:updated_at])
  end
end