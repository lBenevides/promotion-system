class CouponsController < ApplicationController

  def show
    @coupon = Coupon.find(params[:id])
    @promotion = Promotion.find(@coupon.promotion_id)

  end

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


  def search
    if request.post?
      @coupon = Coupon.find_by(code: params[:coupon])

      if @coupon.present?
        redirect_to @coupon, notice: 'Cupom encontrado com sucesso!'
      else
        redirect_to search_coupons_path, notice: 'Cupom não encontrado, por favor insira um código valido'
      end

    end
  end

end