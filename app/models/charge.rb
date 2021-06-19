class Charge < ApplicationRecord
  before_create :attach_token
  validates :additional_params, :customer_complete_name, :customer_cpf, :due_date, presence: {message: 'inválido'}
  
  def attach_token
    token = generate_token
    while Charge.find_by(token: token)
      token = generate_token
    end
    self.token = token
  end
  
  def generate_token
    charset = Array('A'..'Z') + Array('a'..'z') + Array('0'..'9')
    Array.new(20) {charset.sample}.join
  end
end
