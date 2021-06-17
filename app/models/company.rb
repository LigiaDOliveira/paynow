class Company < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :staffs, dependent: :destroy
  has_many :boletos, dependent: :destroy
  has_many :pixes, dependent: :destroy
  has_many :credit_cards, dependent: :destroy
  has_many :payment_methods, through: :pixes
  has_many :payment_methods, through: :boletos
  has_many :payment_methods, through: :credit_cards
  validates :email, email: true 

  def requested_suspension_message
    "Suspensão da empresa #{corporate_name} (Token: #{token}) solicitada"
  end
end
