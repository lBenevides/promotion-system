class AddAvailableToCoupon < ActiveRecord::Migration[6.1]
  def change
    add_column :coupons, :available, :integer, null: false, default: 0
  end
end
