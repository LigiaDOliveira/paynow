require 'rails_helper'

describe 'visitor sees receit' do
  it 'successfully' do
    receipt1 = Receipt.create!(
      auth_code: 'qwertyuiop9876543210',
      pay_date: '22/06/2021',
      due_date: '01/12/2050'
    )
    receipt2 = Receipt.create!(
      auth_code: 'qwertyuiop9876543211',
      pay_date: '23/06/2021',
      due_date: '02/12/2050'
    )
    visit receipt_path(receipt1.auth_code)
    expect(current_path).to eq('/receipts/qwertyuiop9876543210')
    expect(page).to have_text('Recibo')
    expect(page).to have_text('Código de autenticação')
    expect(page).to have_text('Data de vencimento')
    expect(page).to have_text('Data de pagamento')
    expect(page).to have_text('22/06/2021')
    expect(page).to have_text('01/12/2050')
  end
end