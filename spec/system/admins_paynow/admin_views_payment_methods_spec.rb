require 'rails_helper'

describe 'Admin views payment methods' do
  context 'logged in' do
    it 'successfully' do
      admin = AdminPaynow.create!(email: 'adm@paynow.com.br', password: '123456')
      login_as admin, scope: :admin_paynow
      p1 = PaymentMethod.create!(name: 'Boleto bancário do banco laranja',
                                 charging_fee: 10,
                                 maximum_charge: 100,
                                 pay_type: :boleto)
      p1.icon.attach(io: File.open('./spec/files/icon_boleto.png'), filename: 'icon_boleto.png')
      p2 = PaymentMethod.create!(name: 'PIX do banco roxinho',
                                 charging_fee: 20,
                                 maximum_charge: 110,
                                 pay_type: :pix)
      p2.icon.attach(io: File.open('./spec/files/icon_PIX.png'), filename: 'icon_PIX.png')
      p3 = PaymentMethod.create!(name: 'Cartão de crédito PISA',
                                 charging_fee: 30,
                                 maximum_charge: 115,
                                 pay_type: :credit_card)
      p3.icon.attach(io: File.open('./spec/files/icon_credit_card.png'), filename: 'icon_credit_card.png')
      visit root_path
      click_on 'Meios de pagamento'
      expect(current_path).to eq(payment_methods_path)
      expect(page).to have_text('adm@paynow.com.br')
      expect(page).to have_text('Boleto bancário do banco laranja')
      expect(page).to have_text('10%')
      expect(page).to have_text('R$ 100,00')
      expect(page).to have_text('Tipo Boleto')
      expect(page).to have_text('PIX do banco roxinho')
      expect(page).to have_text('20%')
      expect(page).to have_text('R$ 110,00')
      expect(page).to have_text('Tipo PIX')
      expect(page).to have_text('Cartão de crédito PISA')
      expect(page).to have_text('30%')
      expect(page).to have_text('R$ 115,00')
      expect(page).to have_text('Tipo Cartão de Crédito')
      click_on 'Voltar'
      expect(current_path).to eq(root_path)
    end

    it 'and there is no payment method' do
      admin = AdminPaynow.create!(email: 'adm@paynow.com.br', password: '123456')
      login_as admin, scope: :admin_paynow
      visit root_path
      click_on 'Meios de pagamento'
      expect(page).to have_text('adm@paynow.com.br')
      expect(page).to have_text('Nenhum meio de pagamento cadastrado')
    end

    it 'and view details of a payment method' do
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
      expect(page).to have_text('adm@paynow.com.br')
      expect(page).to have_text('Boleto bancário do banco laranja')
      expect(page).to have_text('10%')
      expect(page).to have_text('R$ 100,00')
      expect(page).to have_text('Tipo Boleto')
    end
  end

  context 'not logged' do
    it 'cannot see link to payment methods' do
      p1 = PaymentMethod.create!(name: 'Boleto bancário do banco laranja',
                                 charging_fee: 10,
                                 maximum_charge: 100,
                                 pay_type: :boleto)
      p1.icon.attach(io: File.open('./spec/files/icon_boleto.png'), filename: 'icon_boleto.png')
      p2 = PaymentMethod.create!(name: 'PIX do banco roxinho',
                                 charging_fee: 20,
                                 maximum_charge: 110,
                                 pay_type: :pix)
      p2.icon.attach(io: File.open('./spec/files/icon_PIX.png'), filename: 'icon_PIX.png')
      p3 = PaymentMethod.create!(name: 'Cartão de crédito PISA',
                                 charging_fee: 30,
                                 maximum_charge: 115,
                                 pay_type: :credit_card)
      p3.icon.attach(io: File.open('./spec/files/icon_credit_card.png'), filename: 'icon_credit_card.png')
      visit root_path
      expect(page).to_not have_link('Meios de pagamento')
    end

    it 'cannot access payment methods index' do
      p1 = PaymentMethod.create!(name: 'Boleto bancário do banco laranja',
                                 charging_fee: 10,
                                 maximum_charge: 100,
                                 pay_type: :boleto)
      p1.icon.attach(io: File.open('./spec/files/icon_boleto.png'), filename: 'icon_boleto.png')
      p2 = PaymentMethod.create!(name: 'PIX do banco roxinho',
                                 charging_fee: 20,
                                 maximum_charge: 110,
                                 pay_type: :pix)
      p2.icon.attach(io: File.open('./spec/files/icon_PIX.png'), filename: 'icon_PIX.png')
      p3 = PaymentMethod.create!(name: 'Cartão de crédito PISA',
                                 charging_fee: 30,
                                 maximum_charge: 115,
                                 pay_type: :credit_card)
      p3.icon.attach(io: File.open('./spec/files/icon_credit_card.png'), filename: 'icon_credit_card.png')
      visit payment_methods_path

      expect(current_path).to eq(new_admin_paynow_session_path)
      expect(page).to_not have_text('Boleto bancário do banco laranja')
      expect(page).to_not have_text('10%')
      expect(page).to_not have_text('R$ 100,00')
      expect(page).to_not have_text('Tipo Boleto')
      expect(page).to_not have_text('PIX do banco roxinho')
      expect(page).to_not have_text('20%')
      expect(page).to_not have_text('R$ 110,00')
      expect(page).to_not have_text('Tipo PIX')
      expect(page).to_not have_text('Cartão de crédito PISA')
      expect(page).to_not have_text('30%')
      expect(page).to_not have_text('R$ 115,00')
      expect(page).to_not have_text('Tipo Cartão de Crédito')
      expect(page).to have_text('Criar conta')
      expect(page).to have_text('Email')
      expect(page).to have_text('Senha')
    end
  end
end
