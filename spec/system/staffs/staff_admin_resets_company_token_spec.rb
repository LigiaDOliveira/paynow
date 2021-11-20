require 'rails_helper'

describe 'Staff admin resets company token' do
  let(:company) do
    Company.create!(corporate_name: 'Codeplay',
                    cnpj: '11.111.111/0001-00',
                    email: 'email@codeplay.com.br',
                    address: 'Rua dos Bobos, nº 0',
                    token: 'abcdefghij0123456789')
  end
  let(:adm) do
    Staff.create!(email: 'adm@codeplay.com.br',
                  password: '123456',
                  admin: true, company: company, token: company.token)
  end
  let(:reg) do
    Staff.create!(email: 'regular@codeplay.com.br',
                  password: '123456',
                  admin: false, company: company, token: company.token)
  end
  it 'successfully' do
    login_as adm, scope: :staff
    visit root_path
    click_on 'Minha empresa'
    allow_any_instance_of(CompaniesController).to receive(:generate_token).and_return('um novo token')

    click_on 'Resetar token da empresa'

    expect(page).to_not have_text('abcdefghij0123456789')
    expect(page).to have_text('um novo token')
  end

  it 'and regular staff cannot see link' do
    adm
    login_as reg, scope: :staff
    visit root_path
    click_on 'Minha empresa'
    expect(page).to_not have_link('Resetar token')
    expect(page).to have_text('Codeplay')
    expect(page).to have_text('11.111.111/0001-00')
    expect(page).to have_text('email@codeplay.com.br')
    expect(page).to have_text('Rua dos Bobos, nº 0')
    expect(page).to have_text('abcdefghij0123456789')
  end

  it 'and regular staff cannot force reset token' do
    adm
    login_as reg, scope: :staff
    visit root_path
    click_on 'Minha empresa'
    expect(page).to_not have_link('Resetar token')

    post company_reset_token_path(company)

    expect(page).to have_text('Codeplay')
    expect(page).to have_text('11.111.111/0001-00')
    expect(page).to have_text('email@codeplay.com.br')
    expect(page).to have_text('Rua dos Bobos, nº 0')
    expect(page).to have_text('abcdefghij0123456789')
  end
end
