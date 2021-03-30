require 'application_system_test_case'

class AuthenticationTest < ApplicationSystemTestCase
  test 'user sign up' do
    visit root_path
    click_on 'Cadastrar'
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
    # não logar e ir para o login
    # confirmar conta?
    # validar a qualidade da senha?
    # captcha não sou um robô
  end

  test 'user sign in' do
    user = User.create!(email: 'bene@iugu.com.br', password: 'password')

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

  # TODO: teste de sair
  # TODO: teste de erros ao cadastrar
  # TODO: teste de erros ao logar
  # TODO: teste recuperar senha
  # TODO: traduzir i18n do user
  # TODO: traduzir o edit de usuario
  # TODO: incluir name no user
end