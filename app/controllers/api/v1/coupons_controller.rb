class Api::V1::CouponsController < Api::V1::ApiController

  def show
    @coupon = Coupon.active.find_by!(code: params[:code])
    render json: @coupon
  end 

  def use
    @coupon = Coupon.active.find_by(code: params[:code])
    @coupon.used!
    render json: @coupon
  end

end