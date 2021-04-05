module LoginMacros
  def login_user(user = User.create!(name: 'Lucas Benevides', email: 'bene@iugu.com.br', password: '123456'))
    login_as user, scope: :user
    user
  end
end