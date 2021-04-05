require 'test_helper'

class ProductCategoryFlowTest < ActionDispatch::IntegrationTest
  
  test 'cannot access product category new page without login' do
    get new_product_category_path
    assert_redirected_to new_user_session_path
  end

  test 'cannot create product category without login' do
    post product_categories_path, params: {
      product_category: {name: 'Produto AntiHack', code: 'ANTIHACK'}
    }
    assert_redirected_to new_user_session_path
  end

  test 'can create product category' do
    login_user
    post product_categories_path, params: {
      product_category: {name: 'Produto AntiHack', code: 'ANTIHACK'}
    }
    assert_redirected_to product_category_path(ProductCategory.last)
  end

  test 'cannot view product category index without login' do
    get product_categories_path
    assert_redirected_to new_user_session_path
  end

  test 'cannot view a product category without login' do
    product_category = ProductCategory.create!(name: 'Produto AntiHack', code: 'ANTIHACK')
    get product_category_path(product_category)
    assert_redirected_to new_user_session_path
  end

  test 'cannot get to edit page without login' do
    product_category = ProductCategory.create!(name: 'Produto AntiHack', code: 'ANTIHACK')
    get edit_product_category_path(product_category)
    assert_redirected_to new_user_session_path
  end

  test 'cannot update produt category without login' do
    product_category = ProductCategory.create!(name: 'Produto AntiHac', code: 'ANTIHACK')
    patch product_category_path(product_category), params: {
      product_category: {name: 'Produto AntiHack'}
    }
    assert_redirected_to new_user_session_path
  end

  test 'cannot destroy product category without login' do
    product_category = ProductCategory.create!(name: 'Produto AntiHac', code: 'ANTIHACK')
    delete product_category_path(product_category)    
    assert_redirected_to new_user_session_path
  end


end