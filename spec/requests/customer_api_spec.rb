require 'rails_helper'

describe 'Customer' do
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
  context 'GET /api/v1/customers/:token' do
    xit 'should get customers for a company' do
      adm
      adm2
      customer
      customer1
      customer2
      CustomerToken.create!(customer: customer, company: company)
      CustomerToken.create!(customer: customer2, company: company)
      CustomerToken.create!(customer: customer1, company: company2)
      get "/api/v1/customers/#{company.token}"

      expect(response).to have_http_status(200) 
      expect(response.body).to include(customer.complete_name)
      expect(response.body).to include(customer.cpf)
      expect(response.body).to include(customer2.complete_name)
      expect(response.body).to include(customer2.cpf)
      expect(response.body).to_not include(customer1.complete_name)
      expect(response.body).to_not include(customer1.cpf)
    end
  end

  context 'POST /api/v1/customers' do
    it 'should create a customer' do
      adm
      post '/api/v1/customers', params: {
        customer: {complete_name: 'John Doe', cpf: '00000000000'},
        token: company.token
      }
      expect(response).to have_http_status(201)
      expect(response.content_type).to include('application/json')
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['customer']['complete_name']).to eq('John Doe')
      expect(parsed_body['customer']['cpf']).to eq('00000000000')
      expect(parsed_body['company']['token']).to include(company.token)
      expect(parsed_body['token']).to include('Fh7KSg5XwCRJ9PhvPlk2')
    end

    it 'should create a customer and not repeat data' do
      adm
      adm2
      customer
      CustomerToken.create!(customer: customer, company: company)
      post '/api/v1/customers', params: {
        customer: {complete_name: 'John Doe', cpf: '00000000000'},
        token: company2.token
      }
      expect(response).to have_http_status(201)
      expect(response.content_type).to include('application/json')
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['customer']['complete_name']).to eq('John Doe')
      expect(parsed_body['customer']['cpf']).to eq('00000000000')
      expect(parsed_body['company']['token']).to include(company2.token)
      expect(parsed_body['token']).to include('Fh7KSg5XwCRJ9PhvPlk2')
    end

    it 'and company token must be valid' do
      post '/api/v1/customers', params: {
        customer: {complete_name: 'John Doe', cpf: '00000000000'},
        token: '01234567890123456789'
      }
      expect(response).to have_http_status(422)
    end

    it 'and fields must be valid' do
      company
      post '/api/v1/customers', params: {
        customer: {complete_name: ' ', cpf: ' '},
        token: company.token
      }
      expect(response).to have_http_status(422)
      expect(response.content_type).to include('application/json')
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['complete_name']).to eq(['não pode ficar em branco'])
      expect(parsed_body['cpf']).to eq(['não pode ficar em branco'])
    end
  end
end 