require 'rails_helper'

describe 'Staff registers their company' do
  let(:adm){Staff.create!(email: 'adm@codeplay.com.br', password: '123456')}
  context 'with admin staff logged in' do
    it 'successfully' do
      login_as adm

      visit root_path
      click_on 'Cadastrar empresa'
      fill_in 'Razão social', with: 'Codeplay'
      fill_in 'CNPJ', with: '11.111.111/0001-00'
      fill_in 'Email', with: 'email@codeplay.com.br'
      fill_in 'Endereço', with: 'Rua dos Bobos, nº 0'
      click_on 'Cadastrar empresa'
      expect(page).to have_text('Codeplay')
      expect(page).to have_text(/Token: ([A-Z]|[a-z]|[0-9]){20}/)
      expect(page).to have_text('11.111.111/0001-00')
      expect(page).to have_text('email@codeplay.com.br')
      expect(page).to have_text('Rua dos Bobos, nº 0')
      click_on 'Voltar'
      expect(current_path).to eq(root_path)
      expect(adm.reload.admin).to eq(true)
    end

    xit 'email domain of company cannot be different from email domain of staff' do
      
    end
  end
end