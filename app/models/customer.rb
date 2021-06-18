class Customer < ApplicationRecord
  
  # before_create :attach_token

  # def attach_token
  #   self.customer_token.create!(generate_seed)
  # end

  # def generate_seed
  #   (self.complete_name.chars.map(&:ord).map(&:to_s).join + self.cpf.to_s).to_i
  # end
end
