class PromotionsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show, :new, :create, :generate_coupons, :edit, :update, :destroy]
  before_action :set_find_promotion, only: [:show, :edit, :update, :destroy, :generate_coupons]

  def index
    @promotions = Promotion.all
  end

  def show
  end 

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = Promotion.new(promotion_params)
    if @promotion.save
      redirect_to @promotion
    else
      render :new
    end
  end

  def edit
  end

  def update
    return redirect_to @promotion if @promotion.update(promotion_params)

    render :edit
  end

  def destroy
    if @promotion.destroy
      redirect_to promotions_path, notice: t('.success')
    else
      redirect_to @promotion, notice: t('.failed')
    end
  end

  def generate_coupons
    @promotion.generate_coupons!

    redirect_to @promotion, notice: t('.success')
  end

  private

    def set_find_promotion
      @promotion = Promotion.find(params[:id])
    end

    def promotion_params
      params.require(:promotion).permit(:name, 
                                        :description,
                                        :expiration_date,
                                        :code,
                                        :coupon_quantity,
                                        :discount_rate)
    end
  
end