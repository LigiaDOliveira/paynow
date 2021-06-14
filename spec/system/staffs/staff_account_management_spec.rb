require 'rails_helper'

describe 'Staff account management' do
  let(:company){Company.create!(corporate_name: 'Codeplay',
                                cnpj:'11.111.111/0001-00', 
                                email:'email@codeplay.com.br',
                                address: 'Rua dos Bobos, nº 0',
                                token: 'abcdefghij0123456789')}
  let(:adm){Staff.create!(email: 'adm@codeplay.com.br',
                          password: '123456',
                          admin: true, company: company, token: company.token)}
  
  context 'registration as admin' do
    it 'with email and password' do
      visit root_path
      click_on 'Registrar-me'
      fill_in 'Email', with: 'adm@codeplay.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmação de senha', with: '123456'
      click_on 'Criar conta'
      expect(page).to have_text('Login efetuado com sucesso')
      expect(page).to have_text('adm@codeplay.com.br')
      expect(page).to_not have_link('Registrar-me')
      expect(page).to have_link('Sair')
      expect(page).to have_link('Cadastrar empresa')
      click_on 'Cadastrar empresa'
      fill_in 'Razão social', with: 'Codeplay'
      fill_in 'CNPJ', with: '11.111.111/0001-00'
      fill_in 'Email', with: 'email@codeplay.com.br'
      fill_in 'Endereço', with: 'Rua dos Bobos, nº 0'
      click_on 'Cadastrar empresa'
      expect(page).to have_text('Codeplay')
      expect(page).to have_text('11.111.111/0001-00')
      expect(page).to have_text('email@codeplay.com.br')
      expect(page).to have_text('Rua dos Bobos, nº 0')
    end
  
    it 'and the email is invalid' do
      visit root_path
      click_on 'Registrar-me'
      fill_in 'Email', with: 'adm@gmail.com'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmação de senha', with: '123456'
      click_on 'Criar conta'
      expect(page).to have_text('Email inválido')
      expect(page).to have_link('Registrar-me')
      expect(page).to_not have_link('Sair')
    end
  
    it 'without valid field' do
      visit root_path
      click_on 'Registrar-me'
      fill_in 'Email', with: ''
      fill_in 'Senha', with: ''
      fill_in 'Confirmação de senha', with: ''
      click_on 'Criar conta'
      expect(page).to_not have_text('Login efetuado com sucesso')
      expect(page).to have_content('não pode ficar em branco', count: 2)
      expect(page).to_not have_link('Gerenciar meios de pagamento')
      expect(page).to have_link('Registrar-me')
      expect(page).to_not have_link('Sair')
    end
  
    it 'password does not match confirmation' do
      visit root_path
      click_on 'Registrar-me'
      fill_in 'Email', with: 'adm@paynow.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmação de senha', with: ''
      click_on 'Criar conta'
      expect(page).to_not have_text('Login efetuado com sucesso')
      expect(page).to have_content('Confirmação de senha precisa ser igual à senha')
      expect(page).to_not have_link('Gerenciar meios de pagamento')
      expect(page).to have_link('Registrar-me')
      expect(page).to_not have_link('Sair')
    end
  
    it 'with email not unique' do
      adm = Staff.create!(email: 'adm@codeplay.com.br',password: '123456')
      visit root_path
      click_on 'Registrar-me'
      fill_in 'Email', with: 'adm@codeplay.com.br'
      fill_in 'Senha', with: 'outras'
      fill_in 'Confirmação de senha', with: 'outras'
      click_on 'Criar conta'
      expect(page).to_not have_text('Login efetuado com sucesso')
      expect(page).to have_content('já está em uso')
      expect(page).to_not have_link('Gerenciar meios de pagamento')
      expect(page).to have_link('Registrar-me')
      expect(page).to_not have_link('Sair')
    end
  end

  context 'registration as regular staff' do
    it 'with email and password' do
      adm
      visit root_path
      click_on 'Registrar-me'
      fill_in 'Email', with: 'regular@codeplay.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmação de senha', with: '123456'
      click_on 'Criar conta'
      expect(page).to have_text('Login efetuado com sucesso')
      expect(page).to have_text('regular@codeplay.com.br')
      expect(page).to have_text(/Token: ([A-Z]|[a-z]|[0-9]){20}/)
      expect(page).to_not have_link('Registrar-me')
      expect(page).to have_link('Sair')
      expect(page).to_not have_link('Cadastrar empresa')
      expect(page).to have_link('Minha empresa')
    end

    it 'and the email is invalid' do
      adm
      visit root_path
      click_on 'Registrar-me'
      fill_in 'Email', with: 'regular@gmail.com'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmação de senha', with: '123456'
      click_on 'Criar conta'
      expect(page).to have_text('Email inválido')
      expect(page).to have_link('Registrar-me')
      expect(page).to_not have_link('Sair')
    end

    it 'without valid field' do
      adm
      visit root_path
      click_on 'Registrar-me'
      fill_in 'Email', with: ''
      fill_in 'Senha', with: ''
      fill_in 'Confirmação de senha', with: ''
      click_on 'Criar conta'
      expect(page).to_not have_text('Login efetuado com sucesso')
      expect(page).to have_content('não pode ficar em branco', count: 2)
      expect(page).to_not have_link('Gerenciar meios de pagamento')
      expect(page).to have_link('Registrar-me')
      expect(page).to_not have_link('Sair')
    end

    it 'password does not match confirmation' do
      adm
      visit root_path
      click_on 'Registrar-me'
      fill_in 'Email', with: 'adm@paynow.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmação de senha', with: ''
      click_on 'Criar conta'
      expect(page).to_not have_text('Login efetuado com sucesso')
      expect(page).to have_content('Confirmação de senha precisa ser igual à senha')
      expect(page).to_not have_link('Gerenciar meios de pagamento')
      expect(page).to have_link('Registrar-me')
      expect(page).to_not have_link('Sair')
    end

    it 'with email not unique' do
      adm
      visit root_path
      click_on 'Registrar-me'
      fill_in 'Email', with: 'adm@codeplay.com.br'
      fill_in 'Senha', with: 'outras'
      fill_in 'Confirmação de senha', with: 'outras'
      click_on 'Criar conta'
      expect(page).to_not have_text('Login efetuado com sucesso')
      expect(page).to have_content('já está em uso')
      expect(page).to_not have_link('Gerenciar meios de pagamento')
      expect(page).to have_link('Registrar-me')
      expect(page).to_not have_link('Sair')
    end
  end
end