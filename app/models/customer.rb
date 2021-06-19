class Customer < ApplicationRecord
  has_many :customer_tokens
  has_many :companies, through: :customer_tokens
  validates :complete_name, :cpf, presence: {message: 'não pode ficar em branco'}

  def generate_seed
    (self.complete_name.chars.map(&:ord).map(&:to_s).join + self.cpf.to_s).to_i
  end
end
