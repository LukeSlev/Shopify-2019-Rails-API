class Api::V1::OrdersController < ApplicationController
  before_action :set_shop
  before_action :set_order, only: [:show, :update, :destroy]

  # GET /orders
  def index
    @orders = @shop.orders.all

    render json: @orders
  end

  # GET /orders/1
  def show
    render json: @order
  end

  # POST /orders
  def create
    @order = Order.new(order_params.reverse_merge(shop_id: params['shop_id']))

    if @order.save
      render json: @order, status: :created, location: api_v1_shop_orders_url(@order)
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orders/1
  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_shop
    @shop = current_user.shops.find_by!(id: params[:shop_id])
  end

  def set_order
    @order = @shop.orders.find_by!(id: params[:id]) if @shop
  end

  # Only allow a trusted parameter "white list" through.
  def order_params
    params.require(:order).permit(:date)
  end
end
