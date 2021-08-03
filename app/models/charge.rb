class Charge < ApplicationRecord
  enum pay_type: { boleto: 0, credit_card: 1, pix: 2 }
  before_create :attach_token
  after_update :create_receipt
  validates :additional_params, :customer_complete_name, :customer_cpf, :due_date, presence: { message: 'inválido' }

  def attach_token
    token = generate_token
    token = generate_token while Charge.find_by(token: token)
    self.token = token
  end

  def create_receipt
    if status.eql?('aprovada')
      Receipt.create!(
        auth_code: generate_token,
        pay_date: history[-10, 10],
        due_date: due_date
      )
    end
  end

  def generate_token
    charset = Array('A'..'Z') + Array('a'..'z') + Array('0'..'9')
    Array.new(20) { charset.sample }.join
  end
end
