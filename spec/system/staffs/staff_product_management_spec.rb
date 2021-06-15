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
  let(:prod1){Product.create!(name: 'Curso 1', price: 100, company: company)}
  let(:prod2){Product.create!(name: 'Curso 2', price: 99, sale_discount: 5, company: company)}
  let(:prod3){Product.create!(name: 'Curso 3', price: 98, sale_discount: 3, company: company)}

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

    it 'but there are no products' do
      login_as adm
      visit company_products_path(company)
      expect(page).to have_text('Nenhum produto cadastrado')
    end

    it 'unless logged out' do
      company
      prod1 = Product.create!(name: 'Curso 1', price: 100, company: company)
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

  context 'Staff can click on product and see details' do
    it 'successfully' do 
      login_as adm 
      prod1
      prod2
      prod3
      visit company_products_path(company)
      click_on 'Curso 1'
      expect(current_path).to eq(company_product_path(prod1))
      expect(page).to have_text('Curso 1')
      expect(page).to have_text('R$ 100,00')
      expect(page).to have_text('Desconto: 0%')
      click_on 'Voltar'
      expect(current_path).to eq(company_products_path(company))
    end
  end

  context 'Staff registers new product' do
    it 'successfully' do
      login_as adm
      visit company_products_path(company)
      click_on 'Cadastrar produto'
      expect(current_path).to eq(new_company_product_path(company))
      fill_in 'Nome', with: 'Curso 4'
      fill_in 'Valor do produto', with: 85
      fill_in 'Desconto', with: 10
      click_on 'Cadastrar'
      expect(page).to have_text('Produto cadastrado com sucesso')
      expect(page).to have_text('Curso 4')
      expect(page).to have_text('R$ 85,00')
      expect(page).to have_text('Desconto: 10%')
    end

    it 'with invalid parameters' do
      login_as adm
      visit company_products_path(company)
      click_on 'Cadastrar produto'
      expect(current_path).to eq(new_company_product_path(company))
      fill_in 'Nome', with: ''
      fill_in 'Valor do produto', with: ''
      fill_in 'Desconto', with: ''
      click_on 'Cadastrar'
      expect(page).to have_text('não pode ficar em branco')
    end

    it 'with all fields but sale discount' do
      login_as adm
      visit company_products_path(company)
      click_on 'Cadastrar produto'
      expect(current_path).to eq(new_company_product_path(company))
      fill_in 'Nome', with: 'Curso 4'
      fill_in 'Valor do produto', with: 85
      fill_in 'Desconto', with: ''
      click_on 'Cadastrar'
      expect(page).to have_text('Produto cadastrado com sucesso')
      expect(page).to have_text('Curso 4')
      expect(page).to have_text('R$ 85,00')
      expect(page).to have_text('Desconto: 0%')
      save_page
    end
  end

  context 'Staff edits product' do
    it 'successfully' do
      login_as adm
      prod1
      visit company_product_path(prod1)
      click_on 'Editar'
      fill_in 'Nome', with: 'Curso 4'
      fill_in 'Valor do produto', with: 85
      fill_in 'Desconto', with: 10
      click_on 'Salvar'
      expect(page).to_not have_text('Curso 1')
      expect(page).to_not have_text('R$ 100,00')
      expect(page).to_not have_text('Desconto: 0%')
      expect(page).to have_text('Produto editado com sucesso')
      expect(page).to have_text('Curso 4')
      expect(page).to have_text('R$ 85,00')
      expect(page).to have_text('Desconto: 10%')
      save_page
    end
  end
end