class Company < ApplicationRecord
  has_many :staffs 
  has_many :boletos
  has_many :payment_methods, through: :boletos
  validates :email, email: true 
end
