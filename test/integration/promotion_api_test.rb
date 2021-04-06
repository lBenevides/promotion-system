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
  end
  
end