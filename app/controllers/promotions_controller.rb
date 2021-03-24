class PromotionsController < ApplicationController
  def index
    @promotions = Promotion.all
  end

  def show
    set_find_promotion
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
    set_find_promotion
    set_find_promotion
  end

  def update
    set_find_promotion

    if @promotion.update(promotion_params)
      redirect_to @promotion
    else
      render :edit
    end

  end

  def destroy
    set_find_promotion
    @promotion.destroy

    redirect_to promotions_path
  end

  def generate_coupons
    set_find_promotion
    @promotion.generate_coupons!

    flash[:notice] = "Cupons gerados com sucesso"   
    redirect_to @promotion
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