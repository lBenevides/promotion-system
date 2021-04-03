class Coupon < ApplicationRecord
  belongs_to :promotion

  enum status: { active: 0, disabled: 10  }
  enum available: { available: 0, used: 10 }
end
