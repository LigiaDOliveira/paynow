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
  context 'GET /api/v1/customers' do
    it 'should get customers' do
      adm
      adm2
      customer
      get '/api/v1/customers'

      expect(response).to have_http_status(200) 
      expect(response.body).to include('John Doe')
      expect(response.body).to include('00000000000')
    end
  end
end 