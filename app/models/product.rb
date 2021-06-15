class Product < ApplicationRecord
  belongs_to :company
  before_create :set_token
  before_create :set_sale_discount
  validates :name, :price,
            presence: {message: 'não pode ficar em branco'}

  def set_sale_discount
    self.sale_discount = 0 if self.sale_discount.nil?
  end

  def set_token
    self.token = generate_token if self.token.nil?
  end

  def generate_token
    charset = Array('A'..'Z') + Array('a'..'z') + Array('0'..'9')
    Array.new(20) {charset.sample}.join
  end
end
