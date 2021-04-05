class Promotion < ApplicationRecord
  belongs_to :user
  has_many :coupons, dependent: :restrict_with_error
  has_one :promotion_approval
  has_one :approver, through: :promotion_approval, source: :user

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

  def self.search(query)
    where('name LIKE ?', "%#{query}%")
  end

  def approved?
    promotion_approval.present?  
  end

  def can_approve?(current_user)
    user != current_user
  end
   

  private

    def expiration_date_cannot_be_in_the_past
      return unless expiration_date.present? && expiration_date < Date.current

      errors.add(:expiration_date, t('errors.date_in_past') )
    end 

end
