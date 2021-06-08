require 'rails_helper'

describe 'Admin edits payment methods' do
  xit 'successfully' do
    p1 = PaymentMethod.create!(name: 'Boleto bancário do banco laranja',
      charging_fee:10,
      maximum_charge: 100,
      pay_type: 'boleto')
    p1.icon.attach(io: File.open('./spec/files/icon_boleto.png'), filename: 'icon_boleto.png')

    visit root_path
    click_on 'Meios de pagamento'
    click_on 'Boleto bancário do banco laranja'
    click_on 'Editar'

    expect(current_path).to eq(edit_payment_method_path)
    fill_in 'Nome', with: 'Boleto bancário do banco furtacor'
    click_on 'Salvar'

    expect(page).to have_text('Boleto bancário do banco furtacor')
    expect(page).to have_text('10%')
    expect(page).to have_text('R$ 100,00')
    expect(page).to have_text('Tipo boleto')
    expect(page).to have_css("img[src*='icon_boleto.png']")
  end
end