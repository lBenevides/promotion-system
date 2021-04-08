require 'test_helper'

class PromotionApiTest < ActionDispatch::IntegrationTest

  test 'show' do
    user = User.create!(email: 'bene@iugu.com.br', password: '123456', name: 'lucas')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', 
                                  code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
                                  expiration_date: '22/12/2033', user: user )
    coupon = Coupon.create(code: 'NATAL10-0001', promotion: promotion)

    get "/api/v1/coupons/#{coupon.code}"
    assert_response :ok
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal promotion.discount_rate.to_s, body[:discount_rate]    
  end 

  test 'show cupon not found' do
    get "/api/v1/coupons/0"

    assert_response :not_found
  end

  test 'show coupon disabled' do
    user = User.create!(email: 'bene@iugu.com.br', password: '123456', name: 'lucas')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', 
                                  code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
                                  expiration_date: '22/12/2033', user: user )
    coupon = Coupon.create(code: 'NATAL10-0001', promotion: promotion, status: :disabled)
    get "/api/v1/coupons/#{coupon.code}"
    assert_response :not_found
  end

  test 'use a coupon' do
    user = User.create!(email: 'bene@iugu.com.br', password: '123456', name: 'lucas')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', 
                                  code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
                                  expiration_date: '22/12/2033', user: user )
    coupon = Coupon.create(code: 'NATAL10-0001', promotion: promotion, status: :active )

    patch "/api/v1/coupons/#{coupon.code}/use", params: {
      coupon: {status: :used}
    }
  end
  
end