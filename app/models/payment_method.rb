class PaymentMethod < ApplicationRecord
  has_one_attached :icon
  validates :name, :charging_fee, :maximum_charge,
            :pay_type, presence: {message: 'não pode ficar em branco'}
end
