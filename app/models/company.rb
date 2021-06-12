class Company < ApplicationRecord
  has_many :staffs 
  validates :email, email: true 
end
