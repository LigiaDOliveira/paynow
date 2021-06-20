require 'rails_helper'

describe 'Staff manages charges' do
  let(:company){Company.create!(corporate_name: 'Codeplay',
                                cnpj:'11.111.111/0001-00', 
                                email:'email@codeplay.com.br',
                                address: 'Rua dos Bobos, nº 0',
                                token: 'abcdefghij0123456789')}
  let(:company2){Company.create!(corporate_name: 'Prupru',
                                cnpj:'22.222.222/9992-99', 
                                email:'email@prupru.com.br',
                                address: 'Rua dos Espertos, nº 9',
                                token: 'klmnopqrst0123456789')}
  let(:adm){Staff.create!(email: 'adm@codeplay.com.br',
                              password: '123456',
                              admin: true, company: company, token: company.token)}
  let(:adm2){Staff.create!(email: 'adm@prupru.com.br',
                              password: '123456',
                              admin: true, company: company2, token: company2.token)}        
  let(:reg){Staff.create!(email: 'regular@codeplay.com.br',
                              password: '123456',
                              admin: false, company: company, token: company.token)}
  let(:prod1){Product.create!(name: 'Curso 1', price: 100, company: company)}
  let(:prod2){Product.create!(name: 'Curso 2', price: 99, sale_discount: 5, company: company)}
  let(:prod3){Product.create!(name: 'Curso 3', price: 98, sale_discount: 3, company: company)}
  let(:customer){Customer.create!(complete_name: 'John Doe', cpf: '00000000000')}
  let(:customer1){Customer.create!(complete_name: 'Johanne Doe', cpf: '11111111111')}
  let(:customer2){Customer.create!(complete_name: 'Joana Doe', cpf: '22222222222')}
  let(:pm1) do
    p1 = PaymentMethod.create!(name: 'Boleto bancário do banco laranja',
                               charging_fee:10,
                               maximum_charge: 100,
                               pay_type: 'boleto')
    p1.icon.attach(io: File.open('./spec/files/icon_boleto.png'), filename: 'icon_boleto.png')
    p1
  end
  let(:pm2) do
    p2 = PaymentMethod.create!(name: 'PIX do banco roxinho',
                               charging_fee:20,
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
  context 'by being admin and seeing the charges' do
    it 'successfully' do
      CustomerToken.create!(customer: customer, company: company)
      CustomerToken.create!(customer: customer2, company: company)
      post '/api/v1/charges', params: {
        charge: {
          company_token: company.token,
          product_token: prod1.token, 
          customer_complete_name: customer.complete_name,
          customer_cpf: customer.cpf,
          pay_type: pm1.pay_type,
          due_date: '01/12/2050'
        },
        additional_params:{address: 'Av. Brasil, nº999'}
      }
      post '/api/v1/charges', params: {
        charge: {
          company_token: company.token,
          product_token: prod2.token, 
          customer_complete_name: customer.complete_name,
          customer_cpf: customer.cpf,
          pay_type: pm2.pay_type,
          due_date: '01/12/2050'
        }
      }
      post '/api/v1/charges', params: {
        charge: {
          company_token: company.token,
          product_token: prod2.token, 
          customer_complete_name: customer2.complete_name,
          customer_cpf: customer2.cpf,
          pay_type: pm3.pay_type,
          due_date: '01/12/2050'
        },
        additional_params:{cc_name: 'Fulano Cliente',cc_number: '5381579886310193', cc_cvv: '235'}
      }
      login_as(adm, :scope => :staff)
      visit root_path
      click_on 'Minha empresa'
      click_on 'Cobranças'
      expect(current_path).to eq(company_charges_path)
      expect(page).to have_text(prod1.token)
      expect(page).to have_text(customer.complete_name)
      expect(page).to have_text(customer.cpf)
      expect(page).to have_text(customer2.complete_name)
      expect(page).to have_text(customer2.cpf)
      expect(page).to have_text('01/12/2050')
      expect(page).to have_text(prod2.token)
    end
  end

  context 'by being admin and setting charge status' do
    it 'to rejected' do
      CustomerToken.create!(customer: customer, company: company)
      CustomerToken.create!(customer: customer2, company: company)
      post '/api/v1/charges', params: {
        charge: {
          company_token: company.token,
          product_token: prod1.token, 
          customer_complete_name: customer.complete_name,
          customer_cpf: customer.cpf,
          pay_type: pm1.pay_type,
          due_date: '01/12/2050'
        },
        additional_params:{address: 'Av. Brasil, nº999'}
      }
      post '/api/v1/charges', params: {
        charge: {
          company_token: company.token,
          product_token: prod2.token, 
          customer_complete_name: customer.complete_name,
          customer_cpf: customer.cpf,
          pay_type: pm2.pay_type,
          due_date: '01/12/2050'
        }
      }
      post '/api/v1/charges', params: {
        charge: {
          company_token: company.token,
          product_token: prod2.token, 
          customer_complete_name: customer2.complete_name,
          customer_cpf: customer2.cpf,
          pay_type: pm3.pay_type,
          due_date: '01/12/2050'
        },
        additional_params:{cc_name: 'Fulano Cliente',cc_number: '5381579886310193', cc_cvv: '235'}
      }
      login_as(adm, :scope => :staff)
      visit company_charges_path
      within "div#1.charge" do
        click_on 'Rejeitar cobrança'
      end
      fill_in 'Data da rejeição', with: '05/07/2021'
      fill_in 'Código de retorno', with: '11'
      click_on 'Avançar'
      expect(page).to have_text(prod1.token)
      expect(page).to have_text(customer.complete_name)
      expect(page).to have_text(customer.cpf)
      expect(page).to have_text(customer2.complete_name)
      expect(page).to have_text(customer2.cpf)
      expect(page).to have_text('01/12/2050')
      expect(page).to have_text(prod2.token)
      expect(page).to have_text('Histórico')
      expect(page).to have_text('05/07/2021')
      expect(page).to have_text('11')
    end
    it 'to accepted' do
      CustomerToken.create!(customer: customer, company: company)
      CustomerToken.create!(customer: customer2, company: company)
      post '/api/v1/charges', params: {
        charge: {
          company_token: company.token,
          product_token: prod1.token, 
          customer_complete_name: customer.complete_name,
          customer_cpf: customer.cpf,
          pay_type: pm1.pay_type,
          due_date: '01/12/2050'
        },
        additional_params:{address: 'Av. Brasil, nº999'}
      }
      post '/api/v1/charges', params: {
        charge: {
          company_token: company.token,
          product_token: prod2.token, 
          customer_complete_name: customer.complete_name,
          customer_cpf: customer.cpf,
          pay_type: pm2.pay_type,
          due_date: '01/12/2050'
        }
      }
      post '/api/v1/charges', params: {
        charge: {
          company_token: company.token,
          product_token: prod2.token, 
          customer_complete_name: customer2.complete_name,
          customer_cpf: customer2.cpf,
          pay_type: pm3.pay_type,
          due_date: '01/12/2050'
        },
        additional_params:{cc_name: 'Fulano Cliente',cc_number: '5381579886310193', cc_cvv: '235'}
      }
      login_as(adm, :scope => :staff)
      visit company_charges_path
      within "div#1.charge" do
        click_on 'Aprovar cobrança'
      end
      fill_in 'Data do pagamento', with: '05/07/2021'
      click_on 'Avançar'
      save_page
      expect(page).to have_text(prod1.token)
      expect(page).to have_text(customer.complete_name)
      expect(page).to have_text(customer.cpf)
      expect(page).to have_text(customer2.complete_name)
      expect(page).to have_text(customer2.cpf)
      expect(page).to have_text('01/12/2050')
      expect(page).to have_text(prod2.token)
      expect(page).to have_text('Histórico')
      expect(page).to have_text('05/07/2021')
      expect(page).to have_text('Aprovada')
      within "div#1.charge" do
        expect(page).to_not have_link('Rejeitar cobrança')
        expect(page).to_not have_link('Aprovar cobrança')
      end
    end
  end
end