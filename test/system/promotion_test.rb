require 'application_system_test_case'

class PromotionsTest < ApplicationSystemTestCase
  test 'view promotions' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'

    assert_text 'Natal'
    assert_text 'Promoção de Natal'
    assert_text '10,00%'
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
  end

  test 'view promotion details' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: user)
    
    visit root_path
    click_on 'Promoções'
    click_on 'Cyber Monday'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
  end

  test 'no promotion are available' do
    login_user
    visit root_path
    click_on 'Promoções'

    assert_text 'Nenhuma promoção encontrada'
  end

  test 'view promotions and return to home page' do
    user = login_user

    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    
    visit root_path
    click_on 'Promoções'
    click_on 'Voltar'

    assert_current_path root_path
  end

  test 'view details and return to promotions page' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    
    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Voltar'

    assert_current_path promotions_path
  end

  test 'create promotion' do
    login_user            
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    click_on 'Criar Promoção'

    #assert_current_path promotion_path(Promotion.last)
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
    assert_link 'Voltar'
  end

  test 'create and attributes cannot be blank' do
    login_user
    visit root_path

    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    click_on 'Criar Promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'create and code/name must be unique' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Nome', with: 'Natal'
    fill_in 'Código', with: 'NATAL10'
    click_on 'Criar Promoção'

    assert_text 'já está em uso', count: 2 
  end

  test 'view new promotion form and return to index' do
    login_user

    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    click_on 'Voltar'
    
    assert_current_path promotions_path
  end

  test 'generate cupons for a promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    PromotionApproval.create(promotion: promotion, user: User.new(name: 'admin', 
                                                                  email: 'admin@iugu.com.br', 
                                                                  password: '123456'))
    visit promotion_path(promotion)
    click_on 'Gerar cupons'

    
    assert_text 'Cupons gerados com sucesso'
    assert_no_link 'Gerar cupons'
    assert_no_text 'NATAL10-0000'
    assert_text 'NATAL10-0001'
    assert_text 'NATAL10-0002'
    assert_text 'NATAL10-0003'
    assert_no_text 'NATAL10-0101'
  end

  test 'update promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Ciber', description: 'Promoção de Ciber Monday',
                                  code: 'Ciber10', discount_rate: 10, coupon_quantity: 90 ,
                                  expiration_date: '22/02/2033', user: user)
    
    visit promotion_path(promotion)
    click_on 'Editar Promoção'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '30'
    fill_in 'Data de término', with: '22/12/2033'
    click_on 'Atualizar Promoção'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '30'
    assert_link 'Voltar'
  end

  test 'view edit promotion form and return to index' do
    user = login_user
    promotion = Promotion.create!(name: 'Cyber', description: 'Promoção de Cyber Monday',
                                  code: 'Cyber10', discount_rate: 10, coupon_quantity: 90 ,
                                  expiration_date: '22/02/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Cyber'
    click_on 'Editar Promoção'
    click_on 'Voltar'
    click_on 'Voltar'
    
    assert_current_path promotions_path
  end

  test 'delete promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Cyber', description: 'Promoção de Cyber Monday',
                                  code: 'Cyber10', discount_rate: 10, coupon_quantity: 90 ,
                                  expiration_date: '22/02/2033', user: user)
    visit promotion_path(promotion)
    accept_confirm do
      click_on 'Deletar Promoção'
    end
    
    assert_text 'Promoção deletada com sucesso'
    assert_no_text 'Cyber'
    assert_no_text 'Promoção de Cyber Monday'
    assert_no_text '10,00%'
  end


  test 'cannot delete promotion with generated coupons' do
    user = login_user
    promotion = Promotion.create!(name: 'Cyber', description: 'Promoção de Cyber Monday',
                                  code: 'Cyber10', discount_rate: 10, coupon_quantity: 90 ,
                                  expiration_date: '22/02/2033', user: user)
                                
    PromotionApproval.create(promotion: promotion, user: User.new(name: 'admin', email: 'admin@iugu.com.br', password: '123456'))
    visit promotion_path(promotion)
    click_on 'Gerar cupons'
    accept_confirm do
      click_on 'Deletar Promoção'
    end
    
    assert_text 'Promoção não foi deletada'
    assert_text 'Cyber'
    assert_text 'Promoção de Cyber Monday'
    assert_text '10,00%'
  end

  test 'do not view promotion link' do
    visit root_path

    assert_no_link 'Promoções'
  end

  test 'do not view promotions using route without login' do
    visit promotions_path
  
    assert_current_path new_user_session_path
  end

  test 'do not view promotions details without login' do
    user = User.create!(name: 'lUcas', email: 'bene@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Cyber', description: 'Promoção de Cyber Monday',
                                  code: 'Cyber10', discount_rate: 10, coupon_quantity: 90 ,
                                  expiration_date: '22/02/2033', user: user)
    
    visit promotion_path(promotion)                                  
    
    assert_current_path new_user_session_path
  end

  test 'cannot create promotion withou login' do
    visit new_promotion_path
    
    assert_current_path new_user_session_path
  end

  test 'search promotions by term and find results' do
    user =login_user
    christmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    xmas = Promotion.create!(name: 'Natalina', description: 'Promoção de Natal',
                              code: 'NATAL11', discount_rate: 10, coupon_quantity: 100,
                              expiration_date: '22/12/2033', user: user)
    cyber_monday = Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                                     code: 'Cyber15', discount_rate: 15, coupon_quantity: 30,
                                     expiration_date: '22/12/2033', user: user)
    visit root_path
    click_on 'Promoções'
    fill_in 'Busca', with: 'Natal'
    click_on 'Buscar'

    assert_text christmas.name
    assert_text xmas.name
    refute_text cyber_monday.name
    # TODO: visitar pagina sem estar logado
    # TODO: nao encontrar nada no search
  end

  test 'user aproves promotion' do
    user = User.create!(email: 'gabi@iugu.com.br', name: 'Gabriela', password:'1234567')
    cyber_monday = Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                                     code: 'Cyber15', discount_rate: 15, coupon_quantity: 30,
                                     expiration_date: '22/12/2033', user: user)
    
    approver = login_user
    visit promotion_path(cyber_monday)
    assert_emails 1 do
      accept_confirm { click_on 'Aprovar' }
      assert_text 'Promoção aprovada com sucesso' 
    end

    assert_text "Aprovada por: #{approver.email}"
    assert_text 'Gerar cupons'
    refute_link 'Aprovar'
 
  end

  test 'user cannot aproves promotion' do
    user = login_user
    cyber_monday = Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                                     code: 'Cyber15', discount_rate: 15, coupon_quantity: 30,
                                     expiration_date: '22/12/2033', user: user)
    
    visit promotion_path(cyber_monday)
 
    refute_link 'Aprovar'
    refute_link 'Gerar cupons'
  end

  # TOOD: ajustar os outros testes
end