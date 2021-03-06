class Api::V1::ProductsController < ApplicationController
  before_action :set_shop
  before_action :set_product, only: [:show, :update, :destroy]

  # GET /products
  def index
    @products = @shop.products

    render json: @products, status: :ok
  end

  # GET /products/1
  def show
    render json: @product, status: :ok
  end

  # POST /products
  def create
    @product = Product.new(product_params.reverse_merge(shop_id: params['shop_id']))

    if @product.save
      render json: @product, status: :created, location: api_v1_shop_products_url(@product)
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      render json: @product, status: :ok
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_shop
    @shop = current_user.shops.find_by!(id: params[:shop_id])
  end

  def set_product
    @product = @shop.products.find_by!(id: params[:id]) if @shop
  end

  # Only allow a trusted parameter "white list" through.
  def product_params
    params.require(:product).permit(:name, :cost)
  end
end
