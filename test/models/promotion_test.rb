require "test_helper"

class PromotionTest < ActiveSupport::TestCase
  test 'attributes cannot be blank' do
    promotion = Promotion.new

    refute promotion.valid?
    assert_includes promotion.errors[:name], 'não pode ficar em branco'
    assert_includes promotion.errors[:code], 'não pode ficar em branco'
    assert_includes promotion.errors[:discount_rate], 'não pode ficar em '\
                                                      'branco'
    assert_includes promotion.errors[:coupon_quantity], 'não pode ficar em'\
                                                        ' branco'
    assert_includes promotion.errors[:expiration_date], 'não pode ficar em'\
                                                        ' branco'
  end

  test 'code must be uniq' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    promotion = Promotion.new(code: 'NATAL10')

    refute promotion.valid?
    assert_includes promotion.errors[:code], 'já está em uso'
  end

  test 'generate coupon! succesfully' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    
    promotion.generate_coupons!

    assert promotion.coupons.size == promotion.coupon_quantity
    assert promotion.coupons.first.code == 'NATAL10-0001'
  end

  test 'generate coupon! cannot be called twice' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Coupon.create!(code: 'Blabla', promotion: promotion)
    assert_no_difference 'Coupon.count' do
      promotion.generate_coupons!
    end
  end

  test 'expiration_date cannot be in the past' do
    user = login_user
    error = assert_raises(ActiveRecord::RecordInvalid ) do
      promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                    expiration_date: '22/12/2002', user: user)
    end
    assert_equal 'A validação falhou: Data de término não pode ficar no passado', error.message
  end

  test '.search by exact' do
    user = login_user
    christmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    cyber_monday = Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                                     code: 'Cyber15', discount_rate: 15, coupon_quantity: 30,
                                     expiration_date: '22/12/2033', user: user)
    result = Promotion.search('Natal') 
    assert_includes result, christmas
    refute_includes result, cyber_monday
  end


  test '.search by partial' do
    user = login_user
    christmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                   expiration_date: '22/12/2033', user: user)
    xmas = Promotion.create!(name: 'Natalina', description: 'Promoção de Natal',
                                  code: 'NATAL11', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    cyber_monday = Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                                     code: 'Cyber15', discount_rate: 15, coupon_quantity: 30,
                                     expiration_date: '22/12/2033', user: user)
    result = Promotion.search('Natal') 
    assert_includes result, christmas
    assert_includes result, xmas
    refute_includes result, cyber_monday
  end

  test '.search finds nothing' do
    user = login_user
    christmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                   expiration_date: '22/12/2033', user: user)
    cyber_monday = Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                                     code: 'Cyber15', discount_rate: 15, coupon_quantity: 30,
                                     expiration_date: '22/12/2033', user: user)
    result = Promotion.search('carnaval') 
    assert_empty result
  end
end
