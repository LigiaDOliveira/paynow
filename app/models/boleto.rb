class Boleto < ApplicationRecord
  belongs_to :company
  belongs_to :payment_method
  validates :bank_code, :agency, :account, presence: { message: 'não pode ficar em branco' }
end
