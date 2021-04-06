require 'test_helper'

class PromotionFlowTest < ActionDispatch::IntegrationTest

  test 'can get to new' do
    login_user
    get new_promotion_path
    assert_response :ok
  end

  test 'cannot get to promotion new page without login' do
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
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', 
                                  code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
                                  expiration_date: '22/12/2033', user: user )

    get edit_promotion_path(promotion)
    assert_response :ok
    
  end
  
  test 'cannot get to edit' do
    user = User.new(name: 'admin',  email: 'admin@iugu.com.br', password: '123456') 
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', 
                                  code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
                                  expiration_date: '22/12/2033', user: user )
    
    get edit_promotion_path(promotion)
    assert_redirected_to new_user_session_path
  end

  test 'can update' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', 
                                  code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
                                  expiration_date: '22/12/2033', user: user )
    
    promotion.discount_rate = 10
    
    patch promotion_path(promotion), params: { 
      promotion: { discount_rate: 1}
    }
    assert_redirected_to @promotion

  end

  test 'cannot update view without login' do
    user = User.new(name: 'admin',  email: 'admin@iugu.com.br', password: '123456') 
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', 
                                  code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
                                  expiration_date: '22/12/2033', user: user )
    
    patch promotion_path(promotion), params: { 
      promotion: { discount_rate: 1}
    }
    assert_redirected_to new_user_session_path

  end

  test 'can destroy a promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', 
                                  code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
                                  expiration_date: '22/12/2033', user: user )

    delete promotion_path(promotion)
    assert_redirected_to promotions_path
  end

  test 'cannot destroy a promotion without login' do
    user = User.new(name: 'admin',  email: 'admin@iugu.com.br', password: '123456') 
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', 
                                  code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
                                  expiration_date: '22/12/2033' , user: user)

    delete promotion_path(promotion)
    assert_redirected_to new_user_session_path
  end
 
  test 'can generate coupons' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', 
                                  code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
                                  expiration_date: '22/12/2033', user: user)
    
    post generate_coupons_promotion_path(promotion)
    assert_redirected_to promotion
  end

  test 'cannot generate coupons without login' do
    user = User.new(name: 'admin',  email: 'admin@iugu.com.br', password: '123456') 
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', 
                                  code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
                                  expiration_date: '22/12/2033', user: user )
  
    post generate_coupons_promotion_path(promotion)
    assert_redirected_to new_user_session_path
  end

  # TODO: teste de login de aprovação

  test 'cannot approve if owner' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', 
                                  code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
                                  expiration_date: '22/12/2033', user: user )

    post approve_promotion_path(promotion)
    assert_redirected_to promotion_path(promotion)
    refute promotion.reload.approved?
    assert_equal 'Ação não permitida', flash[:alert]
  end
end