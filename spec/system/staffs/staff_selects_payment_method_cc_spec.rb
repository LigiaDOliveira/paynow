require 'rails_helper'

describe 'Staff manages payment methods' do
  let(:company) do
    Company.create!(corporate_name: 'Codeplay',
                    cnpj: '11.111.111/0001-00',
                    email: 'email@codeplay.com.br',
                    address: 'Rua dos Bobos, nº 0',
                    token: 'abcdefghij0123456789')
  end
  let(:adm) do
    Staff.create!(email: 'adm@codeplay.com.br',
                  password: '123456',
                  admin: true, company: company, token: company.token)
  end
  let(:reg) do
    Staff.create!(email: 'regular@codeplay.com.br',
                  password: '123456',
                  admin: false, company: company, token: company.token)
  end
  let(:pm1) do
    p1 = PaymentMethod.create!(name: 'Boleto bancário do banco laranja',
                               charging_fee: 10,
                               maximum_charge: 100,
                               pay_type: :boleto)
    p1.icon.attach(io: File.open('./spec/files/icon_boleto.png'), filename: 'icon_boleto.png')
    p1
  end
  let(:pm2) do
    p2 = PaymentMethod.create!(name: 'PIX do banco roxinho',
                               charging_fee: 20,
                               maximum_charge: 110,
                               pay_type: :pix)
    p2.icon.attach(io: File.open('./spec/files/icon_PIX.png'), filename: 'icon_PIX.png')
    p2
  end
  let(:pm3) do
    p3 = PaymentMethod.create!(name: 'Cartão de crédito PISA',
                               charging_fee: 30,
                               maximum_charge: 115,
                               pay_type: :credit_card)
    p3.icon.attach(io: File.open('./spec/files/icon_credit_card.png'), filename: 'icon_credit_card.png')
    p3
  end
  let(:credit_card) do
    CreditCard.create!(cc_code: 'abcdefghij0xxx456789',
                       company: company, payment_method: pm3)
  end
  context 'sees available methods' do
    it 'successfully' do
      adm
      pm1
      pm2
      pm3
      login_as adm
      visit root_path
      click_on 'Gerenciar meios de pagamento'
      expect(current_path).to eq(staff_payment_methods_path)
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
    end

    it 'and clicks on one to see details' do
      adm
      pm1
      pm2
      pm3
      login_as adm
      visit staff_payment_methods_path
      click_on 'Cartão de crédito PISA'
      expect(current_path).to eq(staff_payment_method_path(pm3))
      expect(page).to have_text('Cartão de crédito PISA')
      expect(page).to have_text('30%')
      expect(page).to have_text('R$ 115,00')
      expect(page).to have_text('Tipo Cartão de Crédito')
    end

    it 'and adds credit_card type settings' do
      adm
      pm1
      pm2
      pm3
      login_as adm
      visit staff_payment_method_path(pm3)
      click_on 'Configurar'
      expect(current_path).to eq(new_staff_payment_method_credit_card_path(pm3))
      fill_in 'Conta junto à operadora do cartão', with: 'abcdefghij0xxx456789'
      click_on 'Configurar'
      expect(page).to have_text('Cartão de crédito PISA')
      expect(page).to have_text('30%')
      expect(page).to have_text('R$ 115,00')
      expect(page).to have_text('Tipo Cartão de Crédito')
      expect(page).to have_text('abcdefghij0xxx456789')
    end
  end

  context 'and cannot add payment method' do
    it 'because one is already configured' do
      login_as adm
      credit_card
      visit new_staff_payment_method_credit_card_path(pm3)
      expect(current_path).to eq(staff_payment_method_path(pm3))
      expect(page).to have_text('Cartão de crédito PISA')
      expect(page).to have_text('30%')
      expect(page).to have_text('R$ 115,00')
      expect(page).to have_text('Tipo Cartão de Crédito')
      expect(page).to have_text('abcdefghij0xxx456789')
    end

    it 'because cannot see link to configure' do
      login_as adm
      credit_card
      visit staff_payment_method_path(pm3)
      expect(current_path).to eq(staff_payment_method_path(pm3))
      expect(page).to_not have_link('Configurar')
    end
  end

  context 'and edits payment method configuration' do
    it 'for credit_card' do
      login_as adm
      credit_card
      visit staff_payment_method_path(pm3)
      click_on 'Editar'
      expect(current_path).to eq(edit_polymorphic_path([:staff, pm3, credit_card]))
      fill_in 'Conta junto à operadora do cartão', with: '0xxx456789abcdefghij'
      click_on 'Salvar'
      expect(page).to have_text('Cartão de crédito PISA')
      expect(page).to have_text('30%')
      expect(page).to have_text('R$ 115,00')
      expect(page).to have_text('Tipo Cartão de Crédito')
      expect(page).to have_text('0xxx456789abcdefghij')
    end
  end

  context 'and disables payment method' do
    it 'by clicking on button' do
      login_as adm
      credit_card
      visit staff_payment_method_path(pm3)
      click_on 'Desabilitar'
      expect(page).to have_text('Cartão de crédito PISA')
      expect(page).to have_text('30%')
      expect(page).to have_text('R$ 115,00')
      expect(page).to have_text('Tipo Cartão de Crédito')
      expect(page).to_not have_text('abcdefghij0xxx456789')
      expect(page).to have_link('Configurar')
    end
  end
end
