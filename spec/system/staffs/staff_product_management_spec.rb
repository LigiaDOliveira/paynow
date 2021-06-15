require 'rails_helper'

describe 'Product Management' do
  let(:company){Company.create!(corporate_name: 'Codeplay',
                                cnpj:'11.111.111/0001-00', 
                                email:'email@codeplay.com.br',
                                address: 'Rua dos Bobos, nº 0',
                                token: 'abcdefghij0123456789')}
  let(:adm){Staff.create!(email: 'adm@codeplay.com.br',
                          password: '123456',
                          admin: true, company: company, token: company.token)}
  let(:reg){Staff.create!(email: 'regular@codeplay.com.br',
                          password: '123456',
                          admin: false, company: company, token: company.token)}
  let(:prod1){Product.create!(name: 'Curso 1', price: 100)}
  let(:prod2){Product.create!(name: 'Curso 2', price: 99, sale_discount: 5)}
  let(:prod3){Product.create!(name: 'Curso 3', price: 98, sale_discount: 3)}

  context 'Staff can see product list' do
    it 'successfully' do
      login_as adm
      prod1
      prod2
      prod3
      visit root_path
      click_on 'Minha empresa'
      click_on 'Produtos'
      expect(page).to have_text('Curso 1')
      expect(page).to have_text('R$ 100,00')
      expect(page).to have_text('Desconto: 0%')
      expect(page).to have_text('Curso 2')
      expect(page).to have_text('R$ 99,00')
      expect(page).to have_text('Desconto: 5%')
      expect(page).to have_text('Curso 3')
      expect(page).to have_text('R$ 98,00')
      expect(page).to have_text('Desconto: 3%')
      click_on 'Voltar'
      expect(current_path).to eq(company_path(company))
    end

    it 'unless logged out' do
      company
      prod1
      prod2
      prod3
      visit company_products_path
      expect(page).to_not have_text('Curso 1')
      expect(page).to_not have_text('R$ 100,00')
      expect(page).to_not have_text('Desconto: 0%')
      expect(page).to_not have_text('Curso 2')
      expect(page).to_not have_text('R$ 99,00')
      expect(page).to_not have_text('Desconto: 5%')
      expect(page).to_not have_text('Curso 3')
      expect(page).to_not have_text('R$ 98,00')
      expect(page).to_not have_text('Desconto: 3%')
      expect(page).to have_text('Para continuar, efetue login ou registre-se')
      expect(current_path).to eq(new_staff_session_path)
    end
  end
end