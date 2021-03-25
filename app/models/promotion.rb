class Promotion < ApplicationRecord
  has_many :coupons, dependent: :destroy

  validates :name,:code, :discount_rate, :expiration_date,
            :coupon_quantity, presence: true
  validates :code, :name, uniqueness: true

  validate :expiration_date_cannot_be_in_the_past

  def generate_coupons!
    return if coupons.any?

    Coupon.transaction do
      (1..coupon_quantity).each do |number|
        coupons.create!(code: "#{code}-#{'%04d' % number}")
      end
    end

  end


  private

    def expiration_date_cannot_be_in_the_past
      return unless expiration_date.present? && expiration_date < Date.current

      errors.add(:expiration_date, 'não pode ficar no passado')
    end

end
