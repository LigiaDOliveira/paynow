require 'rails_helper'

describe 'Admin views payment methods' do
  it 'successfully' do
    p1 = PaymentMethod.create!(name: 'Boleto bancário do banco laranja',
                          charging_fee:10,
                          maximum_charge: 100,
                          pay_type: 'boleto')
    p1.icon.attach(io: File.open('./spec/files/icon_boleto.png'), filename: 'icon_boleto.png')
    p2 = PaymentMethod.create!(name: 'PIX do banco roxinho',
                          charging_fee:20,
                          maximum_charge: 110,
                          pay_type: 'PIX')
    p2.icon.attach(io: File.open('./spec/files/icon_PIX.png'), filename: 'icon_PIX.png')
    p3 = PaymentMethod.create!(name: 'Cartão de crédito PISA',
                          charging_fee: 30,
                          maximum_charge: 115,
                          pay_type: 'cartão de crédito')
    p3.icon.attach(io: File.open('./spec/files/icon_credit_card.png'), filename: 'icon_credit_card.png')
    visit root_path
    click_on 'Meios de pagamento'
    expect(current_path).to eq(payment_methods_path)
    expect(page).to have_text('Boleto bancário do banco laranja')
    expect(page).to have_text('10%')
    expect(page).to have_text('R$ 100,00')
    expect(page).to have_text('Tipo boleto')
    expect(page).to have_text('PIX do banco roxinho')
    expect(page).to have_text('20%')
    expect(page).to have_text('R$ 110,00')
    expect(page).to have_text('Tipo PIX')
    expect(page).to have_text('Cartão de crédito PISA')
    expect(page).to have_text('30%')
    expect(page).to have_text('R$ 115,00')
    expect(page).to have_text('Tipo cartão de crédito')
    click_on 'Voltar'
    expect(current_path).to eq(root_path)
  end

  it 'and there is no payment method' do
    visit root_path
    click_on 'Meios de pagamento'
    expect(page).to have_text('Nenhum meio de pagamento cadastrado')
  end
end