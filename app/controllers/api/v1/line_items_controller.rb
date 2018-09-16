class Api::V1::LineItemsController < ApplicationController
  before_action :set_shop
  before_action :set_order
  before_action :set_product
  before_action :set_line_item, only: [:show, :update, :destroy]

  # GET /api/v1/shops/:shop_id/orders/:order_id/line_items
  def index
    @line_items = @order.line_items

    render json: @line_items
  end

  # GET /api/v1/shops/:shop_id/orders/:order_id/line_items/1
  def show
    render json: @line_item
  end

  # POST /api/v1/shops/:shop_id/orders/:order_id/line_items
  def create
    @line_item = LineItem.new(line_item_params.reverse_merge(name: @product.name, cost: @product.cost, order_id: params['order_id']))

    if @line_item.save
      render json: @line_item, status: :created, location: api_v1_shop_order_line_items_url(@line_item)
    else
      render json: @line_item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/shops/:shop_id/orders/:order_id/line_items/1
  def update
    if @line_item.update(line_item_params)
      render json: @line_item
    else
      render json: @line_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/shops/:shop_id/orders/:order_id/line_items/1
  def destroy
    @line_item.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_shop
    @shop = Shop.find(params[:shop_id])
  end

  def set_order
    @order = @shop.orders.find_by!(id: params[:order_id]) if @shop
  end

  def set_product
    @product = @shop.products.find_by!(id: params[:line_item][:product_id]) if @shop && params.dig(:line_item, :product_id).present?
  end

  def set_line_item
    @line_item = @order.line_items.find_by!(id: params[:id]) if @order
  end

  # Only allow a trusted parameter "white list" through.
  def line_item_params
    params.require(:line_item).permit(:product_id, :quantity)
  end
end
