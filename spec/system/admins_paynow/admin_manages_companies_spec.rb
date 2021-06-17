require 'rails_helper'

describe 'Admin paynow manages company' do
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
  let(:company2){Company.create!(corporate_name: 'Apolônio',
                                cnpj:'22.222.222/9992-99', 
                                email:'email@apolonio.com.br',
                                address: 'Av. Guaratuba, nº 1',
                                token: 'abcdefghij1123456789')}
  let(:adm2){Staff.create!(email: 'adm@apolonio.com.br',
                          password: '123456',
                          admin: true, company: company2, token: company2.token)}
  let(:reg2){Staff.create!(email: 'regular@apolonio.com.br',
                          password: '123456',
                          admin: false, company: company2, token: company2.token)}
  let(:company3){Company.create!(corporate_name: 'Outra Empresa',
                                cnpj:     ' 33.333.333/8883-88', 
                                email:    'email@outraempresa.com.br',
                                address:  'Outra Rua, nº 3',
                                token:    'abcdefghij2123456789')}
  let(:adm3){Staff.create!(email: 'adm@outraempresa.com.br',
                          password: '123456',
                          admin: true, company: company3, token: company3.token)}
  let(:reg3){Staff.create!(email: 'regular@outraempresa.com.br',
                          password: '123456',
                          admin: false, company: company3, token: company3.token)}   
  
  let(:pm1) do
    p1 = PaymentMethod.create!(name: 'Boleto bancário do banco laranja',
                               charging_fee:10,
                               maximum_charge: 100,
                               pay_type: 'boleto')
    p1.icon.attach(io: File.open('./spec/files/icon_boleto.png'), filename: 'icon_boleto.png')
    p1
  end
  let(:pm2) do
    p2 = PaymentMethod.create!(name: 'PIX do banco roxinho',
                               charging_fee:20,
                               maximum_charge: 110,
                               pay_type: 'PIX')
    p2.icon.attach(io: File.open('./spec/files/icon_PIX.png'), filename: 'icon_PIX.png')
    p2
  end
  let(:pm3) do
    p3 = PaymentMethod.create!(name: 'Cartão de crédito PISA',
                               charging_fee: 30,
                               maximum_charge: 115,
                               pay_type: 'cartão de crédito')
    p3.icon.attach(io: File.open('./spec/files/icon_credit_card.png'), filename: 'icon_credit_card.png')
  end
  let(:boleto){Boleto.create!(bank_code: '123', agency: '4321', account: '99999999',
                              company: company, payment_method: pm1)}
  let(:admPaynow1){AdminPaynow.create!(email: 'adm1@paynow.com.br', password: '123456')}
  let(:admPaynow2){AdminPaynow.create!(email: 'adm2@paynow.com.br', password: '123456')}
  let(:company4){Company.create!(corporate_name: 'Ainda Mais uma Empresa',
                                  cnpj:     ' 44.444.444/7774-77', 
                                  email:    'email@aindamaisuma.com.br',
                                  address:  'Ainda Mais Uma Rua, nº 4',
                                  token:    'abcdefghij3123456789',
                                  suspension_required: true, suspension_required_by_id: admPaynow1.id)}
  let(:adm4){Staff.create!(email: 'adm@aindamaisuma.com.br',
                      password: '123456',
                      admin: true, company: company4, token: company4.token)}
  context 'clicks to see company list' do
    it 'successfully' do
      adm 
      adm2
      adm3
      login_as(admPaynow1, :scope => :admin_paynow)
      visit root_path
      click_on 'Empresas Clientes'
      expect(page).to have_text('Codeplay')
      expect(page).to have_text('11.111.111/0001-00')
      expect(page).to have_text('email@codeplay.com.br')
      expect(page).to have_text('Rua dos Bobos, nº 0')
      expect(page).to have_text('abcdefghij0123456789')
      expect(page).to have_text('Apolônio')
      expect(page).to have_text('22.222.222/9992-99')
      expect(page).to have_text('email@apolonio.com.br')
      expect(page).to have_text('Av. Guaratuba, nº 1')
      expect(page).to have_text('abcdefghij1123456789')
      expect(page).to have_text('Outra Empresa')
      expect(page).to have_text('33.333.333/8883-88')
      expect(page).to have_text('email@outraempresa.com.br')
      expect(page).to have_text('Outra Rua, nº 3')
      expect(page).to have_text('abcdefghij2123456789')
    end
  end
  context 'and clicks to request to suspend company' do
    it 'successfully' do
      adm 
      adm2
      adm3
      login_as(admPaynow1, :scope => :admin_paynow)
      visit companies_path
      within('div#1.company')  do
        click_on 'Solicitar suspensão'
      end
      expect(page).to have_text('Codeplay')
      expect(page).to have_text('11.111.111/0001-00')
      expect(page).to have_text('email@codeplay.com.br')
      expect(page).to have_text('Rua dos Bobos, nº 0')
      expect(page).to have_text('abcdefghij0123456789')
      expect(page).to have_text('Suspensão da empresa Codeplay (Token: abcdefghij0123456789) solicitada')
      expect(page).to have_text('Apolônio')
      expect(page).to have_text('22.222.222/9992-99')
      expect(page).to have_text('email@apolonio.com.br')
      expect(page).to have_text('Av. Guaratuba, nº 1')
      expect(page).to have_text('abcdefghij1123456789')
      expect(page).to have_text('Outra Empresa')
      expect(page).to have_text('33.333.333/8883-88')
      expect(page).to have_text('email@outraempresa.com.br')
      expect(page).to have_text('Outra Rua, nº 3')
      expect(page).to have_text('abcdefghij2123456789')
    end
  end
  context 'Another admin confirms requests' do
    it 'successfully' do
      admPaynow1
      adm 
      adm2
      adm3
      adm4
      login_as(admPaynow2, :scope => :admin_paynow)
      visit companies_path
      within "div##{company4.id}.company" do
        click_on 'Confirmar suspensão'
      end
      expect(page).to have_text('Empresa desligada')
      expect(page).to_not have_text('Ainda Mais uma Empresa')
      expect(page).to_not have_text('44.444.444/7774-77')
      expect(page).to_not have_text('email@aindamaisuma.com.br')
      expect(page).to_not have_text('Ainda Mais Uma Rua, nº 4')
      expect(page).to_not have_text('abcdefghij3123456789')
    end
  end
end