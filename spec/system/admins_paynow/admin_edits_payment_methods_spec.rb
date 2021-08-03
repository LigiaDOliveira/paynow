require 'rails_helper'

describe 'Admin edits payment methods' do
  context 'logged in' do
    it 'successfully' do
      admin = AdminPaynow.create!(email: 'adm@paynow.com.br', password: '123456')
      login_as admin, scope: :admin_paynow
      p1 = PaymentMethod.create!(name: 'Boleto bancário do banco laranja',
                                 charging_fee: 10,
                                 maximum_charge: 100,
                                 pay_type: :boleto)
      p1.icon.attach(io: File.open('./spec/files/icon_boleto.png'), filename: 'icon_boleto.png')

      visit root_path
      click_on 'Meios de pagamento'
      click_on 'Boleto bancário do banco laranja'
      click_on 'Editar'
      fill_in 'Nome', with: 'Boleto bancário do banco furtacor'
      fill_in 'Taxa de cobrança', with: 10
      fill_in 'Cobrança máxima', with: 100
      select('Boleto', from: 'Tipo')
      attach_file 'Ícone', './spec/files/icon_boleto.png'
      click_on 'Salvar'

      expect(page).to have_text('Boleto bancário do banco furtacor')
      expect(page).to have_text('10%')
      expect(page).to have_text('R$ 100,00')
      expect(page).to have_text('Tipo Boleto')
      expect(page).to have_css("img[src*='icon_boleto.png']")

      click_on 'Voltar'
      expect(current_path).to eq(payment_methods_path)
    end

    it 'with invalid attributes' do
      admin = AdminPaynow.create!(email: 'adm@paynow.com.br', password: '123456')
      login_as admin, scope: :admin_paynow
      p1 = PaymentMethod.create!(name: 'Boleto bancário do banco laranja',
                                 charging_fee: 10,
                                 maximum_charge: 100,
                                 pay_type: 'boleto')
      p1.icon.attach(io: File.open('./spec/files/icon_boleto.png'), filename: 'icon_boleto.png')
      visit root_path
      click_on 'Meios de pagamento'
      click_on 'Boleto bancário do banco laranja'
      click_on 'Editar'
      fill_in 'Nome', with: ''
      fill_in 'Taxa de cobrança', with: ''
      fill_in 'Cobrança máxima', with: ''
      click_on 'Salvar'

      expect(page).to have_text('não pode ficar em branco', count: 3)
    end
  end

  context 'logged out' do
    it 'cannot access payment method details' do
      p1 = PaymentMethod.create!(name: 'Boleto bancário do banco laranja',
                                 charging_fee: 10,
                                 maximum_charge: 100,
                                 pay_type: 'boleto')
      p1.icon.attach(io: File.open('./spec/files/icon_boleto.png'), filename: 'icon_boleto.png')
      visit payment_method_path(p1)
      expect(current_path).to eq(new_admin_paynow_session_path)
      expect(page).to have_text('Criar conta')
      expect(page).to have_text('Email')
      expect(page).to have_text('Senha')
    end

    it 'cannot edit payment method' do
      p1 = PaymentMethod.create!(name: 'Boleto bancário do banco laranja',
                                 charging_fee: 10,
                                 maximum_charge: 100,
                                 pay_type: 'boleto')
      p1.icon.attach(io: File.open('./spec/files/icon_boleto.png'), filename: 'icon_boleto.png')
      visit edit_payment_method_path(p1)
      expect(current_path).to eq(new_admin_paynow_session_path)
      expect(page).to have_text('Criar conta')
      expect(page).to have_text('Email')
      expect(page).to have_text('Senha')
    end
  end
end
