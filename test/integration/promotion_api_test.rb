require 'test_helper'

class PromotionApiTest < ActionDispatch::IntegrationTest

  test 'show' do
    coupon = Fabricate(:coupon)

    get "/api/v1/coupons/#{coupon.code}"

    assert_response :ok
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal coupon.discount_rate.to_s, body[:discount_rate]    
  end 

  test 'show cupon not found' do
    get "/api/v1/coupons/0"
  
    assert_response :not_found
  end

  test 'show coupon disabled' do

    coupon = Fabricate(:coupon, status: :disabled)
    get "/api/v1/coupons/#{coupon.code}"
    assert_response :not_found
  end

  test 'use a coupon' do
    coupon = Fabricate(:coupon)

    patch "/api/v1/coupons/#{coupon.code}/use", params: {
      coupon: {status: :used}
    }
  end
end