class Charge < ApplicationRecord
  after_update :create_receipt
  before_create :attach_token
  validates :additional_params, :customer_complete_name, :customer_cpf, :due_date, presence: {message: 'inválido'}
  
  def attach_token
    token = generate_token
    while Charge.find_by(token: token)
      token = generate_token
    end
    self.token = token
  end

  def create_receipt
    Receipt.create!(
      auth_code: generate_token,
      pay_date: self.history[-10,10],
      due_date: self.due_date
    ) if self.status.eql?('aprovada')
  end
  
  def generate_token
    charset = Array('A'..'Z') + Array('a'..'z') + Array('0'..'9')
    Array.new(20) {charset.sample}.join
  end
end
