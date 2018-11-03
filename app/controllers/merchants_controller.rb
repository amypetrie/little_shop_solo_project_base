class MerchantsController < ApplicationController
  def index
    if current_admin?
      @merchants = User.where(role: :merchant).order(:name)
    else
      @merchants = User.where(role: :merchant, active: true).order(:name)
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
