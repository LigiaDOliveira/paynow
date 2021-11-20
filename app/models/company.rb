class Company < ApplicationRecord
  has_many :boletos, dependent: :destroy
  has_many :credit_cards, dependent: :destroy
  has_many :customers, through: :customer_tokens
  has_many :customer_tokens, dependent: :restrict_with_error
  has_many :payment_methods, through: :boletos
  has_many :payment_methods, through: :credit_cards
  has_many :payment_methods, through: :pixes
  has_many :pixes, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :staffs, dependent: :destroy
  validates :email, email: true

  def destroy_allowed?(user)
    suspension_required? && !suspension_required_by.eql?(user)
  end

  def requested_suspension_message
    "Suspensão da empresa #{corporate_name} (Token: #{token}) solicitada"
  end

  def suspension_required_by
    Staff.find suspension_required_by_id
  end
end
