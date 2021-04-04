require 'test_helper'

class PromotionFlowTest < ActionDispatch::IntegrationTest

  test 'can get to new' do
    login_user
    get new_promotion_path
    assert_response :ok
  end

  test 'cannot get to new without login' do
    get new_promotion_path
    assert_redirected_to new_user_session_path
  end

  test 'can create a promotion' do
    login_user
    post '/promotions', params: {
      promotion: { name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10', 
                   discount_rate: 15, coupon_quantity: 5, expiration_date: '22/12/2033' }
    }
    assert_redirected_to promotion_path(Promotion.last)
    follow_redirect!
    assert_select 'h3', 'Natal'
  end

  test 'cannot create a promotion without login' do
    post '/promotions', params: {
      promotion: { name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10', 
                   discount_rate: 15, coupon_quantity: 5, expiration_date: '22/12/2033' }
    }
    assert_redirected_to new_user_session_path
  end

  test 'can get to edit' do
    login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', 
                                  code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
                                  expiration_date: '22/12/2033' )

    get edit_promotion_path(promotion)
    assert_response :ok
    
  end
  
  test 'cannot get to edit' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', 
                                  code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
                                  expiration_date: '22/12/2033' )
    
    get edit_promotion_path(promotion)
    assert_redirected_to new_user_session_path
  end

  test 'can update' do
    login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', 
                                  code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
                                  expiration_date: '22/12/2033' )
    
    promotion.discount_rate = 10
    
    patch promotion_path(promotion), params: { 
      promotion: { discount_rate: 1}
    }
    assert_redirected_to @promotion

  end

  test 'cannot update view without login' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', 
                                  code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
                                  expiration_date: '22/12/2033' )
    
    patch promotion_path(promotion), params: { 
      promotion: { discount_rate: 1}
    }
    assert_redirected_to new_user_session_path

  end

  test 'can destroy a promotion' do
    login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', 
                                  code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
                                  expiration_date: '22/12/2033' )

    delete promotion_path(promotion)
    assert_redirected_to promotions_path
  end

  test 'cannot destroy a promotion without login' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', 
                                  code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
                                  expiration_date: '22/12/2033' )

    delete promotion_path(promotion)
    assert_redirected_to new_user_session_path
  end
 
  test 'can generate coupons' do
    login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', 
                                  code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
                                  expiration_date: '22/12/2033' )
    
    post generate_coupons_promotion_path(promotion)
    assert_redirected_to promotion
  end

  test 'cannot generate coupons without login' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', 
                                  code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
                                  expiration_date: '22/12/2033' )
  
    post generate_coupons_promotion_path(promotion)
    assert_redirected_to new_user_session_path
  end

 

  # TODO: testes de product_category
end