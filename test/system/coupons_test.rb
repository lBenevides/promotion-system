require 'application_system_test_case'

class CouponsTest < ApplicationSystemTestCase
  test 'disable a coupon' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    coupon = Coupon.create(code: 'NATAL10-0001', promotion: promotion)
    
    visit promotion_path(promotion)
    within 'div#NATAL10-0001' do
      click_on 'Desabilitar'
      assert_text "#{coupon.code} (desabilitado)"
    end
    assert_text "Cupom #{coupon.code} desabilitado com sucesso"

  end

  test 'active a coupon' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    coupon = Coupon.create(code: 'NATAL10-0001', promotion: promotion)
    coupon.disabled!

    visit promotion_path(promotion)
    within 'div#NATAL10-0001' do
      click_on 'Ativar'
      assert_text "#{coupon.code} (ativado)"
    end

    assert_text "Cupom #{coupon.code} ativado com sucesso"
  end

  test 'search for a valid coupon' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    coupon = Coupon.create(code: 'NATAL10-0001', promotion: promotion)
      
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

  test 'search for a invalid coupon' do
    login_user
    visit root_path
    click_on 'Buscar Cupom'

    fill_in 'Cupom', with: 'NATAL10-0001'
    click_on 'Buscar'

    assert_current_path search_coupons_path
    assert_text 'Cupom não encontrado, por favor insira um código valido' 
  end

  test 'view coupom and return to home page' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    coupon = Coupon.create(code: 'NATAL10-0001', promotion: promotion)

    visit root_path
    click_on 'Buscar Cupom'

    fill_in 'Cupom', with: coupon.code
    click_on 'Buscar'
    click_on 'Voltar'
    click_on 'Voltar'

    assert_current_path root_path
  end

end