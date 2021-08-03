require 'rails_helper'

describe 'Product Management' do
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

    it 'unless staff from other company' do
      prod1
      login_as adm2
      visit company_products_path(company)
      expect(page).to_not have_text('Curso 1')
      expect(page).to_not have_text('R$ 100,00')
      expect(page).to_not have_text('Desconto: 0%')
      expect(page).to have_text('Permissão negada')
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

    it 'unless staff of another company' do
      prod1
      login_as adm2
      visit company_product_path(prod1)
      expect(page).to_not have_text('Curso 1')
      expect(page).to_not have_text('R$ 100,00')
      expect(page).to_not have_text('Desconto: 0%')
      expect(page).to have_text('Permissão negada')
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
    end

    it 'unless staff of another company' do
      adm
      login_as adm2
      visit new_company_product_path(company)
      expect(page).to_not have_text('Nome')
      expect(page).to_not have_text('Valor do produto')
      expect(page).to_not have_text('Desconto')
      expect(page).to have_text('Permissão negada')
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
    end
    it 'unless staff of another company' do
      adm
      prod1
      login_as adm2
      visit edit_company_product_path(prod1)
      expect(page).to_not have_text('Nome')
      expect(page).to_not have_text('Valor do produto')
      expect(page).to_not have_text('Desconto')
      expect(page).to have_text('Permissão negada')
    end
  end

  context 'Staff deletes product' do
    it 'successfully' do
      login_as adm
      prod1
      visit company_product_path(prod1)
      click_on 'Apagar'
      expect(page).to have_text('Produto apagado com sucesso')
      expect(page).to have_text('Nenhum produto cadastrado')
      expect(page).to_not have_text('Curso 1')
      expect(page).to_not have_text('R$ 100,00')
      expect(page).to_not have_text('Desconto: 0%')
    end

    it 'unless staff of another company' do
      adm
      prod1
      login_as adm2
      page.driver.submit :delete, company_product_path(prod1), {}
      expect(page).to_not have_text('Produto apagado com sucesso')
      expect(page).to have_text('Permissão negada')
    end
  end
end
