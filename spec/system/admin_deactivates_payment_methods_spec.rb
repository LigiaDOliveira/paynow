require 'rails_helper'

describe 'Admin deactivates payment methods' do
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
    visit root_path
    click_on 'Meios de pagamento'
    click_on 'Boleto bancário do banco laranja'
    click_on 'Apagar'
    expect(current_path).to eq(payment_methods_path)
    expect(page).to have_text('Meio de pagamento apagado com sucesso')
    expect(page).to_not have_text('Boleto bancário do banco laranja')
    expect(page).to_not have_text('10%')
    expect(page).to_not have_text('R$ 100,00')
    expect(page).to_not have_text('Tipo boleto')
    expect(page).to have_text('PIX do banco roxinho')
    expect(page).to have_text('20%')
    expect(page).to have_text('R$ 110,00')
    expect(page).to have_text('Tipo PIX')
    click_on 'Voltar'
  end
end