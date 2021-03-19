class PromotionsController < ApplicationController
  def index
    @promotions = Promotion.all
  end

  def show
    @promotion = Promotion.find(params[:id]) 
  end 

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = Promotion.new(promotion_params)
    @promotion.save
    
    redirect_to @promotion
  end
  
  private

  def promotion_params
    params.require(:promotion).permit(:name, 
                                      :description,
                                      :expiration_date,
                                      :code,
                                      :coupon_quantity,
                                      :discount_rate)
  end
  
end