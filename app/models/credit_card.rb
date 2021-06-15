class CreditCard < ApplicationRecord
  belongs_to :company
  belongs_to :payment_method
  validates :cc_code, presence: {message: 'não pode ficar em branco'}
end
