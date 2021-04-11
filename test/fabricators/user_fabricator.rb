Fabricator(:user) do
  email { sequence(:email) { |i| "bene#{i}@iugu.com.br" } }
  password '123456'
  name 'Lucas Benevides'
end