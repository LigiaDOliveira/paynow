require 'securerandom'
class CustomerToken < ApplicationRecord
  before_create :generate_token
  belongs_to :customer
  belongs_to :company

  def generate_token(generate_seed)
    self.token = Random.new(generate_seed).alphanumeric(20)
  end

end
