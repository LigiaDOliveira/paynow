class Staff < ApplicationRecord
  belongs_to :company, optional: true
  before_create :associate_company
  validates :email, email: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  def associate_company
    comp = find_company
    self.company = comp
    self.token = comp.token unless comp.nil?
  end

  def find_company
    companies = Company.all
    cmp = companies.select do |c|
      c.email[/@(.)*$/] == email[/@(.)*$/]
    end
    cmp.first
  end

  def active_for_authentication?
    super && staff_active
  end

  def allowed_on?(other_company)
    company == other_company && admin?
  end

  def inactive_message
    'Esta conta foi bloqueada pelo administrador'
  end

  def staff_status
    return 'Ativo' if staff_active?

    'Bloqueado'
  end

  def staff_permission
    return 'Administrador' if admin?

    'Comum'
  end
end
