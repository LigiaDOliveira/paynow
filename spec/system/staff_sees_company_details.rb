require 'rails_helper'

describe 'Staff sees company details' do
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
  it 'successfully' do
    login_as adm
    visit root_path
    click_on 'Minha empresa'
    expect(page).to have_text('Codeplay')
    expect(page).to have_text('11.111.111/0001-00')
    expect(page).to have_text('email@codeplay.com.br')
    expect(page).to have_text('Rua dos Bobos, nº 0')
    expect(page).to have_text('abcdefghij0123456789')
  end
end