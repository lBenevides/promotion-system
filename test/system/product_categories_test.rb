require 'application_system_test_case'

class ProductCategoriesTest < ApplicationSystemTestCase
  test 'view product categories' do
    login_user
    ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')
    ProductCategory.create!(name: 'Produto Secreto', code: 'SECRETO')

    visit root_path
    click_on 'Categorias de Produtos'

    assert_text 'Produto AntiFraude'
    assert_text 'Produto Secreto'
    assert_text 'ANTIFRA'
    assert_text 'SECRETO'
  end

  test 'view product categories details' do
    login_user
    ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')

    visit product_categories_path
    click_on 'Produto AntiFraude'

    assert_text 'Produto AntiFraude'
    assert_text 'ANTIFRA'
  end

  test 'no categories available' do
    login_user
    visit root_path
    click_on 'Categorias de Produtos'

    assert_text 'Nenhuma categoria de produto cadastrada'
  end

  test 'visit product category details and return to home page' do
    login_user
    ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')

    visit root_path
    click_on 'Categorias de Produtos'
    click_on 'Produto AntiFraude'
    click_on 'Voltar'
    click_on 'Voltar'
  end

  test 'create a product category and return to index page' do
    login_user
    visit product_categories_path
    click_on 'Criar Categoria de Produto'
    fill_in 'Nome', with: 'Produto AntiFurto'
    fill_in 'Código', with: 'ANTIFUR'
    click_on 'Criar categoria'

    assert_text 'Produto AntiFurto'
    assert_text 'ANTIFUR'
    click_on 'Voltar'
  end

  test 'try to create a product with blank attributes' do
    login_user
    visit product_categories_path
    click_on 'Criar Categoria de Produto'
    fill_in 'Nome', with: ' '
    fill_in 'Código', with: 'ANTIFUR'
    click_on 'Criar categoria'

    assert_text 'não pode ficar em branco', count: 1
  end

  test 'try to create a product category with same name' do
    login_user
    ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')

    visit product_categories_path
    click_on 'Criar Categoria de Produto'
    fill_in 'Nome', with: 'Produto AntiFraude'
    fill_in 'Código', with: 'ANTIFRA'
    click_on 'Criar categoria'

    assert_text 'já está em uso', count: 2
  end

  test 'update a product category' do
    login_user
    product_category = ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')

    visit product_category_path(product_category)
    click_on 'Editar Categoria de Produto'
    fill_in 'Nome', with: 'Produto AntiHack'
    fill_in 'Código', with: 'ANTIHACK'
    click_on 'Editar categoria'

    assert_text 'Produto AntiHack'
    assert_text 'ANTIHACK'
    click_on 'Voltar'
  end

  test 'delete a product category with another on database' do
    login_user
    product_category = ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')
    ProductCategory.create!(name: 'Produto AntiHack', code: 'ANTIHACK')

    visit product_category_path(product_category)
    click_on 'Deletar Categoria'

    assert_no_text 'Produto AntiFraude'
    assert_no_text 'ANTIFRA'
    assert_text 'Produto AntiHack'
    assert_text 'ANTIHACK'
  end

  test 'delete the only product category' do
    login_user
    product_category = ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')

    visit product_category_path(product_category)
    click_on 'Deletar Categoria'

    assert_no_text 'Produto AntiFraude'
    assert_no_text 'ANTIFRA'
    assert_text 'Nenhuma categoria de produto cadastrada'
  end

end