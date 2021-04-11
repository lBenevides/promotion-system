require 'test_helper'

class PromotionMailerTest < ActionMailer::TestCase
  test 'approval email' do
    user = Fabricate(:user, email: 'approver@iugu.com.br')
    promotion = Fabricate(:promotion, name: 'Carnaval')
    email = PromotionMailer.approval_email(approver: user, promotion: promotion)

    assert_emails(1) {email.deliver_now}
    assert_equal [promotion.user.email], email.to
    assert_includes email.body, user.email
    assert_equal 'Sua promoção "Carnaval" foi aprovada', email.subject 
  end
end