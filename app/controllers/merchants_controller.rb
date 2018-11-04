class MerchantsController < ApplicationController
  def index
    @merchants = User.where(role: :merchant, active: true)
    @top_selling_merchants = @merchants.most_items_sold_past_month
    @most_orders_fulfilled = @merchants.most_fulfilled_orders_past_month
    if current_user || current_admin?
      @fastest_merchants_to_user_city = User.fastest_merchants_to_user_city(current_user)
      @fastest_merchants_to_user_state = current_user.fastest_merchants_to_user_state
      @merchants = User.where(role: :merchant).order(:name) if current_admin?
    end
  end

  def show
    render file: 'errors/not_found', status: 404 unless current_user

    @merchant = User.find(params[:id])
    @total_items_sold = @merchant.total_items_sold
    @top_3_shipping_states = @merchant.top_3_shipping_states
    @top_3_shipping_cities = @merchant.top_3_shipping_cities
    @most_active_buyer = @merchant.top_active_user
    @biggest_order = @merchant.biggest_order
    @top_buyers = @merchant.top_buyers
    if current_admin?
      @orders = current_user.merchant_orders
      if @merchant.user?
        redirect_to user_path(@merchant)
      end
    elsif current_user != @merchant
      render file: 'errors/not_found', status: 404
    end
  end
end
