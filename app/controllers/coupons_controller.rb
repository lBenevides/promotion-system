class CouponsController < ApplicationController
  def disable
    @coupon = Coupon.find(params[:id])
    @coupon.disabled!
    redirect_to @coupon.promotion, notice: t('coupons.disabled.success', code: @coupon.code)
  end

  def active
    @coupon = Coupon.find(params[:id])
    @coupon.active!
    redirect_to @coupon.promotion, notice: t('coupons.actived.success', code: @coupon.code)
  end
end