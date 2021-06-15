class Pix < ApplicationRecord
  belongs_to :company
  belongs_to :payment_method
  validates :pix_key, :bank_code, presence: {message: 'não pode ficar em branco'}
end
