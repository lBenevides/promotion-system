require 'application_system_test_case'

class AuthenticationTest < ApplicationSystemTestCase
  test 'user sign up' do
    visit root_path
    click_on 'Cadastrar'
    fill_in 'Nome', with: 'Lucas Benevides'
    fill_in 'Email', with: 'bene@iugu.com.br'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirmação de senha', with: 'password'
    within 'form' do
      click_on 'Cadastrar'
    end

    assert_text 'Boas vindas! Cadastrou e entrou com sucesso'
    assert_text 'bene@iugu.com.br'
    assert_link 'Sair'
    assert_no_link 'Entrar'
    assert_current_path root_path
    
  end

  test 'user sign up error: password too short' do
    visit root_path
    click_on 'Cadastrar'
    fill_in 'Nome', with: 'Lucas benevides'
    fill_in 'Email', with: 'bene@iugu.com'
    fill_in 'Senha', with: '123'
    fill_in 'Confirmação de senha', with: '123'
    within 'div.actions' do
      click_on 'Cadastrar'
    end

    assert_text 'Senha é muito curto (mínimo: 6 caracteres)'
  end

  test 'user sign up error: password do not match' do
    visit root_path
    click_on 'Cadastrar'
    fill_in 'Nome', with: 'Lucas benevides'
    fill_in 'Email', with: 'bene@iugu.com'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirmação de senha', with: '1234567'
    within 'div.actions' do
      click_on 'Cadastrar'
    end

    assert_text 'Confirmação de senha não é igual a Senha'
  end

  test 'user sign in' do
    user = User.create!(name: 'Lucas Benevides', email: 'bene@iugu.com.br', password: 'password')

    visit root_path
    click_on 'Entrar'
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: user.password
    click_on 'Log in'

    assert_text 'Login efetuado com sucesso!'
    assert_current_path root_path
    assert_link 'Sair'
    assert_no_link 'Entrar'
  end

  test 'user sign in error: wrong password' do
    user = User.create!(name: 'Lucas Benevides', email: 'bene@iugu.com.br', password: 'password')

    visit root_path
    click_on 'Entrar'
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: '123456'
    click_on 'Log in'
    
    assert_text 'Email ou senha inválida'
  end

  test 'user sign in error: non existing email' do
    user = User.create!(name: 'Lucas Benevides', email: 'bene@iugu.com.br', password: 'password')

    visit root_path
    click_on 'Entrar'
    fill_in 'Email', with: 'lhbo@gmail.com'
    fill_in 'Senha', with: user.password
    click_on 'Log in'
    
    assert_text 'Email ou senha inválida'
    
  end

  test 'user sign out' do
    login_user

    visit root_path
    click_on 'Sair'
    
    assert_current_path root_path
    assert_text 'Saiu com sucesso.'
    assert_link 'Entrar'
    assert_link 'Cadastrar'
    assert_no_link 'Sair'
  end

  test 'user forgot password' do
    # TODO: teste recuperar senha | fazer depois
=begin
    user = User.create!(name: 'Lucas Benevides', email: 'bene@iugu.com.br', password: 'password')
    
    visit root_path
    click_on 'Entrar'
    click_on 'Forgot your password?'
    fill_in 'Email', with: user.email
    
    assert_text 'Email ou senha inválida'
=end
  end


  # TODO: Password not strong enough | utilizar STRONGPassword gem depois
  # TODO: traduzir i18n do user
  # TODO: traduzir o edit de usuario
  # não logar e ir para o login
  # confirmar conta?
  # captcha não sou um robô
end