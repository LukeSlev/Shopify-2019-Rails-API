# frozen_string_literal: true

class Api::V1::ShopsController < ApplicationController
  before_action :set_shop, only: %i[show update destroy]

  # GET /shops
  def index
    @shops = current_user.shops

    render json: @shops, status: :ok
  end

  # GET /shops/1
  def show
    render json: @shop, status: :ok
  end

  # POST /shops
  def create
    @shop = current_user.shops.new(shop_params)

    if @shop.save
      render json: @shop, status: :created, location: api_v1_shops_url(@shop)
    else
      render json: @shop.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shops/1
  def update
    if @shop.update(shop_params)
      render json: @shop, status: :ok
    else
      render json: @shop.errors, status: :unprocessable_entity
    end
  end

  # DELETE /shops/1
  def destroy
    @shop.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_shop
    @shop = current_user.shops.find_by!(id: params[:shop_id])
  end

  # Only allow a trusted parameter "white list" through.
  def shop_params
    params.require(:shop).permit(:name)
  end
end
