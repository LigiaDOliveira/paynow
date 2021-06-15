class Product < ApplicationRecord
  before_create :set_token
  validates :name, :price, :sale_discount,
            presence: {message: 'não pode ficar em branco'}
  
  def set_token
    self.token = generate_token
  end

  def generate_token
    charset = Array('A'..'Z') + Array('a'..'z') + Array('0'..'9')
    Array.new(20) {charset.sample}.join
  end
end
