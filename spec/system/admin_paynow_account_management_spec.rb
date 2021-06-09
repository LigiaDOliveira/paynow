require 'rails_helper'

describe 'Paynow admin account management' do
  context 'registration' do
    it 'with email and password' do
      visit root_path
      click_on 'Registrar-me'
      fill_in 'Email', with: 'adm@paynow.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmação de senha', with: '123456'
      click_on 'Criar conta'
      expect(page).to have_text('Login efetuado com sucesso')
      expect(page).to have_text('adm@paynow.com.br')
      expect(page).to have_link('Meios de pagamento')
      expect(page).to_not have_link('Registrar-me')
      expect(page).to have_link('Sair')
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
      expect(page).to_not have_link('Meios de pagamento')
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
      expect(page).to_not have_link('Meios de pagamento')
      expect(page).to have_link('Registrar-me')
      expect(page).to_not have_link('Sair')
    end
  
    it 'with email not unique' do
      adm = AdminPaynow.create!(email: 'adm@paynow.com.br',password: '123456')
      visit root_path
      click_on 'Registrar-me'
      fill_in 'Email', with: 'adm@paynow.com.br'
      fill_in 'Senha', with: 'outras'
      fill_in 'Confirmação de senha', with: 'outras'
      click_on 'Criar conta'
      expect(page).to_not have_text('Login efetuado com sucesso')
      expect(page).to have_content('já está em uso')
      expect(page).to_not have_link('Meios de pagamento')
      expect(page).to have_link('Registrar-me')
      expect(page).to_not have_link('Sair')
    end
  end

  context 'sign in' do
    it 'successfully' do
      admin = AdminPaynow.create!(email: 'adm@paynow.com.br',password: '123456')
      visit root_path
      click_on 'Entrar'
      fill_in 'Email', with: 'adm@paynow.com.br'
      fill_in 'Senha', with: '123456'
      click_on 'Login'
      expect(page).to have_text('Login efetuado com sucesso')
      expect(page).to have_text('adm@paynow.com.br')
      expect(page).to have_link('Meios de pagamento')
      expect(page).to_not have_link('Registrar-me')
      expect(page).to have_link('Sair')
    end

    it 'wrong password' do
      admin = AdminPaynow.create!(email: 'adm@paynow.com.br',password: '123456')
      visit root_path
      click_on 'Entrar'
      fill_in 'Email', with: 'adm@paynow.com.br'
      fill_in 'Senha', with: '654321'
      click_on 'Login'
      expect(page).to have_text('Email ou senha inválida')
      expect(page).to_not have_text('adm@paynow.com.br')
      expect(page).to_not have_link('Meios de pagamento')
      expect(page).to_not have_link('Sair')
    end

    it 'unregistered account' do
      admin = AdminPaynow.create!(email: 'adm@paynow.com.br',password: '123456')
      visit root_path
      click_on 'Entrar'
      fill_in 'Email', with: 'adm2@paynow.com.br'
      fill_in 'Senha', with: '654321'
      click_on 'Login'
      expect(page).to have_text('Email ou senha inválida')
      expect(page).to_not have_text('adm@paynow.com.br')
      expect(page).to_not have_text('adm2@paynow.com.br')
      expect(page).to_not have_link('Meios de pagamento')
      expect(page).to_not have_link('Sair')
    end

  end
end