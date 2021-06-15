class PaymentMethod < ApplicationRecord
  has_many :boletos
  has_many :pixes
  has_many :credit_cards
  has_many :companies, through: :boletos
  has_many :companies, through: :pixes
  has_many :companies, through: :credit_cards
  has_one_attached :icon
  validates :name, :charging_fee, :maximum_charge,
            :pay_type, presence: {message: 'não pode ficar em branco'}
end
