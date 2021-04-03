require 'application_system_test_case'

class CouponsTest < ApplicationSystemTestCase
  test 'disable a coupon' do
    #arrange
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')
    coupon = Coupon.create(code: 'NATAL10-0001', promotion: promotion)
    
    login_user
    visit promotion_path(promotion)
    click_on 'Desabilitar'

    #TODO: create a within 'div' do here

    assert_text "Cupom #{coupon.code} desabilitado com sucesso"
    assert_text "#{coupon.code} (desabilitado)"
  end

  test 'active a coupon' do
    #arrange
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')
    coupon = Coupon.create(code: 'NATAL10-0001', promotion: promotion)
    coupon.disabled!

    login_user
    visit promotion_path(promotion)
    click_on 'Ativar'

    #TODO: create a within 'div' do here

    assert_text "Cupom #{coupon.code} ativado com sucesso"
    assert_text "#{coupon.code} (ativado)"
  end

  test 'search for a valid coupon' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')
    coupon = Coupon.create(code: 'NATAL10-0001', promotion: promotion)
      
    login_user
    visit root_path
    click_on 'Buscar Cupom'

    fill_in 'Cupom', with: coupon.code
    click_on 'Buscar'

    assert_text 'Cupom encontrado com sucesso!'
    assert_text 'Natal'
    assert_text 'Promoção de Natal'
    assert_text '10,00%'
    assert_text '22/12/2033'
    assert_text 'NATAL10-0001'
    assert_text 'Disponivel'
    assert_text 'Ativado'
  end
  

end