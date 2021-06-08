require 'rails_helper'

describe 'Admin edits payment methods' do
  it 'successfully' do
    p1 = PaymentMethod.create!(name: 'Boleto bancário do banco laranja',
      charging_fee:10,
      maximum_charge: 100,
      pay_type: 'boleto')
    p1.icon.attach(io: File.open('./spec/files/icon_boleto.png'), filename: 'icon_boleto.png')

    visit root_path
    click_on 'Meios de pagamento'
    click_on 'Boleto bancário do banco laranja'
    click_on 'Editar'
    fill_in 'Nome', with: 'Boleto bancário do banco furtacor'
    fill_in 'Taxa de cobrança', with: 10
    fill_in 'Cobrança máxima', with: 100
    fill_in 'Tipo', with: 'boleto'
    attach_file 'Ícone', './spec/files/icon_boleto.png'
    click_on 'Salvar'

    expect(page).to have_text('Boleto bancário do banco furtacor')
    expect(page).to have_text('10%')
    expect(page).to have_text('R$ 100,00')
    expect(page).to have_text('Tipo boleto')
    expect(page).to have_css("img[src*='icon_boleto.png']")

    click_on 'Voltar'
    expect(current_path).to eq(payment_methods_path)
  end

  it 'with invalid attributes' do
    p1 = PaymentMethod.create!(name: 'Boleto bancário do banco laranja',
      charging_fee:10,
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
    fill_in 'Tipo', with: ''
    click_on 'Salvar'

    expect(page).to have_text('não pode ficar em branco', count: 4)
  end
end