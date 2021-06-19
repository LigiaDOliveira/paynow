require 'rails_helper'

describe 'emmit charge solicitation' do
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
  let(:boleto){Boleto.create!(bank_code: '123', agency: '4321', account: '99999999',
                              company: company, payment_method: pm1)}
  context 'by getting the tokens for the company and the product,'\
          'the payment method and the customer data' do
    it "and payment method is boleto" do
      prod1
      pm1
      login_as adm, scope: :staff
      boleto
      logout
      customer
      CustomerToken.create!(customer: customer, company: company)
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
      expect(response.status).to eq(201)
      expect(response.content_type).to include('application/json')
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['company_token']).to eq(company.token)
      expect(parsed_body['product_token']).to eq(prod1.token)
      expect(parsed_body['pay_type']).to eq(pm1.pay_type)
      expect(parsed_body['customer_complete_name']).to eq(customer.complete_name)
      expect(parsed_body['customer_cpf']).to eq(customer.cpf)
      expect(parsed_body['original_value'].to_f).to eq(prod1.price)
      expect(parsed_body['discount_value'].to_f).to eq(prod1.price-prod1.price*prod1.sale_discount/100)
      expect(parsed_body['customer_cpf']).to eq(customer.cpf)
      expect(parsed_body['additional_params']).to eq('Endereço: Av. Brasil, nº999')
    end
    
    it "and payment method is credit card" do
      prod2
      pm3
      login_as adm, scope: :staff
      boleto
      logout
      customer
      CustomerToken.create!(customer: customer, company: company)
      post '/api/v1/charges', params: {
        charge: {
          company_token: company.token,
          product_token: prod2.token, 
          customer_complete_name: customer.complete_name,
          customer_cpf: customer.cpf,
          pay_type: pm3.pay_type,
          due_date: '01/12/2050'
        },
        additional_params:{cc_name: 'Fulano Cliente',cc_number: '5381579886310193', cc_cvv: '235'}
      }
      expect(response.status).to eq(201)
      expect(response.content_type).to include('application/json')
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['company_token']).to eq(company.token)
      expect(parsed_body['product_token']).to eq(prod2.token)
      expect(parsed_body['pay_type']).to eq(pm3.pay_type)
      expect(parsed_body['customer_complete_name']).to eq(customer.complete_name)
      expect(parsed_body['customer_cpf']).to eq(customer.cpf)
      expect(parsed_body['original_value'].to_f).to eq(prod2.price)
      expect(parsed_body['discount_value'].to_f).to eq(prod2.price-prod2.price*prod2.sale_discount/100)
      expect(parsed_body['customer_cpf']).to eq(customer.cpf)
      expect(parsed_body['additional_params']).to eq("Nº do cartão: 5381579886310193\n"\
                                                     "Nome no cartão: Fulano Cliente\n"\
                                                     "Código de segurança: 235")
    end

    it "and payment method is PIX" do
      prod3
      pm2
      login_as adm, scope: :staff
      boleto
      logout
      customer
      CustomerToken.create!(customer: customer, company: company)
      post '/api/v1/charges', params: {
        charge: {
          company_token: company.token,
          product_token: prod3.token, 
          customer_complete_name: customer.complete_name,
          customer_cpf: customer.cpf,
          pay_type: pm2.pay_type,
          due_date: '01/12/2050'
        }
      }
      expect(response.status).to eq(201)
      expect(response.content_type).to include('application/json')
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['company_token']).to eq(company.token)
      expect(parsed_body['product_token']).to eq(prod3.token)
      expect(parsed_body['pay_type']).to eq(pm2.pay_type)
      expect(parsed_body['customer_complete_name']).to eq(customer.complete_name)
      expect(parsed_body['customer_cpf']).to eq(customer.cpf)
      expect(parsed_body['original_value'].to_f).to eq(prod3.price)
      expect(parsed_body['discount_value'].to_f).to eq(prod3.price-prod3.price*prod3.sale_discount/100)
      expect(parsed_body['customer_cpf']).to eq(customer.cpf)
      expect(parsed_body['additional_params']).to eq("Nenhum")
    end

    it 'and cannot do boleto without additional params' do
      prod1
      pm1
      login_as adm, scope: :staff
      boleto
      logout
      customer
      CustomerToken.create!(customer: customer, company: company)
      post '/api/v1/charges', params: {
        charge: {
          company_token: company.token,
          product_token: prod1.token, 
          customer_complete_name: customer.complete_name,
          customer_cpf: customer.cpf,
          pay_type: pm1.pay_type,
          due_date: '01/12/2050'
        }
      }
      expect(response.status).to eq(422)
      expect(response.content_type).to include('application/json')
    end

    it 'and cannot do credit card without additional params' do
      prod1
      pm3
      login_as adm, scope: :staff
      logout
      customer
      CustomerToken.create!(customer: customer, company: company)
      post '/api/v1/charges', params: {
        charge: {
          company_token: company.token,
          product_token: prod1.token, 
          customer_complete_name: customer.complete_name,
          customer_cpf: customer.cpf,
          pay_type: pm3.pay_type,
          due_date: '01/12/2050'
        }
      }
      expect(response.status).to eq(422)
      expect(response.content_type).to include('application/json')
    end

    it "and cannot if product invalid" do
      prod3
      pm2
      login_as adm, scope: :staff
      boleto
      logout
      customer
      CustomerToken.create!(customer: customer, company: company)
      post '/api/v1/charges', params: {
        charge: {
          company_token: company.token,
          product_token: '', 
          customer_complete_name: customer.complete_name,
          customer_cpf: customer.cpf,
          pay_type: pm2.pay_type,
          due_date: '01/12/2050'
        }
      }
      expect(response.status).to eq(404)
    end

    it "and cannot if company invalid" do
      prod3
      pm2
      login_as adm, scope: :staff
      boleto
      logout
      customer
      CustomerToken.create!(customer: customer, company: company)
      post '/api/v1/charges', params: {
        charge: {
          company_token: 'sdadsadsda',
          product_token: prod3.token, 
          customer_complete_name: customer.complete_name,
          customer_cpf: customer.cpf,
          pay_type: pm2.pay_type,
          due_date: '01/12/2050'
        }
      }
      expect(response.status).to eq(404)
    end
  end
end