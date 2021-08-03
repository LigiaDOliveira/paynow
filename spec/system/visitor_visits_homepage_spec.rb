require 'rails_helper'

describe 'Visitor visits homepage' do
  it 'successfully' do
    visit root_path

    expect(page).to have_text('PayNow')
    expect(page).to have_text('Boas vindas à plataforma de pagamentos PayNow!')
  end
end
