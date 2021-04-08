class RemoveAvailabletToCoupons < ActiveRecord::Migration[6.1]
  def change
    remove_column :coupons, :available, :integer
  end
end
