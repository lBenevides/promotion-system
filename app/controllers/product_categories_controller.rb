class ProductCategoriesController < ApplicationController
  before_action :authenticate_user!


  def index
    @product_categories = ProductCategory.all
  end
  
  def show
    find_product_category
  end

  def new
    @product_category = ProductCategory.new
  end
  
  def create
    @product_category = ProductCategory.new(product_category_params)

    if @product_category.save
      redirect_to @product_category
    else
      render :new
    end
  end

  def edit
    find_product_category
  end
  
  def update
    find_product_category
    
    if @product_category.update(product_category_params)
      redirect_to @product_category
    else
      render :edit
    end
  end

  def destroy
    find_product_category
    @product_category.destroy
    redirect_to product_categories_path
  end

  
  private
  
    def find_product_category
      @product_category = ProductCategory.find(params[:id])
    end

    def product_category_params
      params.require(:product_category).permit(:name, :code)
    end


end