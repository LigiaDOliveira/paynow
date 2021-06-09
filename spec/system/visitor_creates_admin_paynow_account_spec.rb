require 'rails_helper'

describe 'Visitor creates admin account' do
  it 'with email and password' do
    visit root_path
    click_on 'Registrar-me'
    fill_in 'Email', with: 'adm@paynow.com.br'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirmação de Senha', with: '123456'
    click_on 'Criar conta'
    expect(page).to have_text('Login efetuado com sucesso')
    expect(page).to have_text('adm@paynow.com.br')
    expect(page).to have_link('Meios de pagamento')
    expect(page).to_not have_link('Registrar-me')
    expect(page).to have_link('Sair')
  end
end