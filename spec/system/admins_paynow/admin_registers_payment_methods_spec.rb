require 'rails_helper'

describe 'Admin registers payment methods' do
  context 'logged in' do
    it 'successfully' do
      admin = AdminPaynow.create!(email: 'adm@paynow.com.br', password: '123456')
      login_as admin, scope: :admin_paynow
      visit root_path
      click_on 'Meios de pagamento'
      click_on 'Cadastrar meio de pagamento'
      expect(current_path).to eq(new_payment_method_path)
      fill_in 'Nome', with: 'Boleto bancário do banco laranja'
      fill_in 'Taxa de cobrança', with: 10
      fill_in 'Cobrança máxima', with: 100
      select('Boleto', from: 'Tipo')
      attach_file 'Ícone', './spec/files/icon_boleto.png'
      click_on 'Enviar'
      expect(current_path).to eq(payment_methods_path)
      expect(page).to have_text('adm@paynow.com.br')
      expect(page).to have_text('Boleto bancário do banco laranja')
      expect(page).to have_text('10%')
      expect(page).to have_text('R$ 100,00')
      expect(page).to have_text('Tipo Boleto')
      expect(page).to have_css("img[src*='icon_boleto.png']")
    end

    it 'and attributes cannot be blank' do
      admin = AdminPaynow.create!(email: 'adm@paynow.com.br', password: '123456')
      login_as admin, scope: :admin_paynow
      visit new_payment_method_path
      fill_in 'Nome', with: ''
      fill_in 'Taxa de cobrança', with: ''
      fill_in 'Cobrança máxima', with: ''
      click_on 'Enviar'

      expect(page).to have_text('adm@paynow.com.br')
      expect(page).to have_text('não pode ficar em branco', count: 3)
      save_page
    end
  end

  context 'logged out' do
    it 'cannot register payment methods' do
      visit new_payment_method_path
      expect(current_path).to eq(new_admin_paynow_session_path)
      expect(page).to have_text('Criar conta')
      expect(page).to have_text('Email')
      expect(page).to have_text('Senha')
    end
  end
end
