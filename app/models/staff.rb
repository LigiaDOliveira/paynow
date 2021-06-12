class Staff < ApplicationRecord
  belongs_to :company, optional: true
  before_create :associate_company
  validates :email, :email => true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  def associate_company
    self.company = find_company
  end

  def find_company
    companies = Company.all
    cmp = companies.select do |c|
     c.email[/@(.)*$/] == self.email[/@(.)*$/]
    end
    cmp.first
  end
end
