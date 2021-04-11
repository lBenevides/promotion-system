Fabricator(:promotion) do
  name 'Natal'
  description 'Promoção de Natal'
  code { sequence(:code) { |i| "NATAL1#{i}" } }
  discount_rate 15
  coupon_quantity 5
  expiration_date '22/12/2033'
  user
end