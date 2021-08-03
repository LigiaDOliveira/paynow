require 'rails_helper'

describe 'visitor sees receit' do
  let(:company) do
    Company.create!(corporate_name: 'Codeplay',
                    cnpj: '11.111.111/0001-00',
                    email: 'email@codeplay.com.br',
                    address: 'Rua dos Bobos, nº 0',
                    token: 'abcdefghij0123456789')
  end
  let(:company2) do
    Company.create!(corporate_name: 'Prupru',
                    cnpj: '22.222.222/9992-99',
                    email: 'email@prupru.com.br',
                    address: 'Rua dos Espertos, nº 9',
                    token: 'klmnopqrst0123456789')
  end
  let(:adm) do
    Staff.create!(email: 'adm@codeplay.com.br',
                  password: '123456',
                  admin: true, company: company, token: company.token)
  end
  let(:adm2) do
    Staff.create!(email: 'adm@prupru.com.br',
                  password: '123456',
                  admin: true, company: company2, token: company2.token)
  end
  let(:reg) do
    Staff.create!(email: 'regular@codeplay.com.br',
                  password: '123456',
                  admin: false, company: company, token: company.token)
  end
  let(:prod1) { Product.create!(name: 'Curso 1', price: 100, company: company) }
  let(:prod2) { Product.create!(name: 'Curso 2', price: 99, sale_discount: 5, company: company) }
  let(:prod3) { Product.create!(name: 'Curso 3', price: 98, sale_discount: 3, company: company) }
  let(:customer) { Customer.create!(complete_name: 'John Doe', cpf: '00000000000') }
  let(:customer1) { Customer.create!(complete_name: 'Johanne Doe', cpf: '11111111111') }
  let(:customer2) { Customer.create!(complete_name: 'Joana Doe', cpf: '22222222222') }
  let(:pm1) do
    p1 = PaymentMethod.create!(name: 'Boleto bancário do banco laranja',
                               charging_fee: 10,
                               maximum_charge: 100,
                               pay_type: 'boleto')
    p1.icon.attach(io: File.open('./spec/files/icon_boleto.png'), filename: 'icon_boleto.png')
    p1
  end
  let(:pm2) do
    p2 = PaymentMethod.create!(name: 'PIX do banco roxinho',
                               charging_fee: 20,
                               maximum_charge: 110,
                               pay_type: 'PIX')
    p2.icon.attach(io: File.open('./spec/files/icon_PIX.png'), filename: 'icon_PIX.png')
    p2
  end
  let(:pm3) do
    p3 = PaymentMethod.create!(name: 'Cartão de crédito PISA',
                               charging_fee: 30,
                               maximum_charge: 115,
                               pay_type: 'cartão de crédito')
    p3.icon.attach(io: File.open('./spec/files/icon_credit_card.png'), filename: 'icon_credit_card.png')
    p3
  end
  let(:boleto) do
    Boleto.create!(bank_code: '123', agency: '4321', account: '99999999',
                   company: company, payment_method: pm1)
  end
  it 'successfully' do
    receipt1 = Receipt.create!(
      auth_code: 'qwertyuiop9876543210',
      pay_date: '22/06/2021',
      due_date: '01/12/2050'
    )
    receipt2 = Receipt.create!(
      auth_code: 'qwertyuiop9876543211',
      pay_date: '23/06/2021',
      due_date: '02/12/2050'
    )
    visit receipt_path(receipt1.auth_code)
    expect(current_path).to eq('/receipts/qwertyuiop9876543210')
    expect(page).to have_text('Recibo')
    expect(page).to have_text('Código de autenticação')
    expect(page).to have_text('Data de vencimento')
    expect(page).to have_text('Data de pagamento')
    expect(page).to have_text('22/06/2021')
    expect(page).to have_text('01/12/2050')
  end
  it 'after approving charge' do
    prod1
    pm1
    login_as adm, scope: :staff
    boleto
    logout
    customer
    CustomerToken.create!(customer: customer, company: company)
    allow_any_instance_of(Charge).to receive(:generate_token).and_return('asdfg')
    post '/api/v1/charges', params: {
      charge: {
        company_token: company.token,
        product_token: prod1.token,
        customer_complete_name: customer.complete_name,
        customer_cpf: customer.cpf,
        pay_type: pm1.pay_type,
        due_date: '01/12/2050'
      },
      additional_params: { address: 'Av. Brasil, nº999' }
    }
    Charge.last.update(status: 'aprovada', history: 'Aprovada em 22/06/2021')
    visit receipt_path('asdfg')
    expect(page).to have_text('Recibo')
    expect(page).to have_text('Código de autenticação')
    expect(page).to have_text('Data de vencimento')
    expect(page).to have_text('Data de pagamento')
    expect(page).to have_text('22/06/2021')
    expect(page).to have_text('01/12/2050')
  end
end
