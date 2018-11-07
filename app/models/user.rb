class User < ApplicationRecord
  has_secure_password

  has_many :orders
  has_many :items

  validates_presence_of :name, :address, :city, :state, :zip
  validates :email, presence: true, uniqueness: true

  enum role: %w(user merchant admin)
  def fastest_merchants_to_user_state
  end

  def order_items_by_city
    # WORKS
    User.select('order_items.*')
      .joins(orders: {order_items: :item})
      .where('orders.status != ?', :cancelled)
      .where('users.city = ?', self.city)
      .pluck('order_items.id')
  end

  def fastest_merchants_to_user_city
    order_item_ids = self.order_items_by_city.pluck(:id)

    User.select("distinct users.*,
      CASE
        WHEN order_items.updated_at > order_items.created_at THEN coalesce(EXTRACT(EPOCH FROM order_items.updated_at) - EXTRACT(EPOCH FROM order_items.created_at),0)
        ELSE 1000000000 END as time_diff")
      .joins(:items)
      .joins('join order_items on items.id=order_items.item_id')
      .joins('join orders on orders.id=order_items.order_id')
      .where('order_items.id = ?', order_item_ids)
      .where('orders.status != ?', :cancelled)
      .group('users.id, order_items.updated_at, order_items.created_at')
      .order("time_diff")
  end

  def merchant_orders(status=nil)
    if status.nil?
      Order.distinct.joins(:items).where('items.user_id=?', self.id)
    else
      Order.distinct.joins(:items).where('items.user_id=? AND orders.status=?', self.id, status)
    end
  end

  def merchant_for_order(order)
    !Order.distinct.joins(:items).where('items.user_id=? and orders.id=?', self.id, order.id).empty?
  end

  def total_items_sold
    items
      .joins(:orders)
      .where("orders.status != ?", :cancelled)
      .where("order_items.fulfilled=?", true)
      .sum("order_items.quantity")
  end

  def total_inventory
    items.sum(:inventory)
  end

  def top_shipping(metric, quantity)
    items
      .joins(:orders)
      .joins('join users on orders.user_id=users.id')
      .where("orders.status != ?", :cancelled)
      .where("order_items.fulfilled=?", true)
      .order("count(users.#{metric}) desc")
      .group("users.#{metric}")
      .limit(quantity)
      .pluck("users.#{metric}")
  end

  def top_3_shipping_states
    top_shipping(:state, 3)
  end

  def top_3_shipping_cities
    top_shipping(:city, 3)
  end

  def top_active_user
    User
      .select('users.*, count(orders.id) as order_count')
      .joins(:orders)
      .joins('join order_items on orders.id=order_items.order_id')
      .joins('join items on order_items.item_id=items.id')
      .where('orders.status != ?', :cancelled)
      .where('order_items.fulfilled = ?', true)
      .where('items.user_id = ? AND users.active=?', id, true)
      .group(:id)
      .order('order_count desc')
      .limit(1)
      .first
  end

  def biggest_order
    Order
      .select('orders.*, sum(order_items.quantity) as item_count')
      .joins(:items)
      .where('orders.status != ?', :cancelled)
      .where('order_items.fulfilled = ?', true)
      .where('items.user_id=?', id)
      .order('order_items.quantity desc')
      .group('items.user_id, orders.id, order_items.id')
      .limit(1)
      .first
  end

  def top_buyers(quantity=3)
    User
      .select('users.*, sum(order_items.quantity*order_items.price) as total_spent')
      .joins(:orders)
      .joins('join order_items on orders.id=order_items.order_id')
      .joins('join items on order_items.item_id=items.id')
      .where('orders.status != ?', :cancelled)
      .where('order_items.fulfilled = ?', true)
      .where('items.user_id = ? AND users.active=?', id, true)
      .group(:id)
      .order('total_spent desc')
      .limit(quantity)
  end

  def self.top_merchants(quantity)
    select('distinct users.*, sum(order_items.quantity*order_items.price) as total_earned')
      .joins(:items)
      .joins('join order_items on items.id=order_items.item_id')
      .joins('join orders on orders.id=order_items.order_id')
      .where('orders.status != ?', :cancelled)
      .where('order_items.fulfilled = ?', true)
      .group('orders.id, users.id, order_items.id')
      .order('total_earned desc, users.name')
      .limit(quantity)
  end

  def self.popular_merchants(quantity)
    select('users.*, coalesce(count(order_items.id),0) as total_orders')
      .joins('join items on items.user_id=users.id')
      .joins('join order_items on order_items.item_id=items.id')
      .joins('join orders on orders.id=order_items.order_id')
      .where('orders.status != ?', :cancelled)
      .where('order_items.fulfilled = ?', true)
      .group(:id)
      .order('total_orders desc, users.name asc')
      .limit(quantity)
  end

  def self.merchant_by_speed(quantity, order)
    select("distinct users.*,
      CASE
        WHEN order_items.updated_at > order_items.created_at THEN coalesce(EXTRACT(EPOCH FROM order_items.updated_at) - EXTRACT(EPOCH FROM order_items.created_at),0)
        ELSE 1000000000 END as time_diff")
      .joins(:items)
      .joins('join order_items on items.id=order_items.item_id')
      .joins('join orders on orders.id=order_items.order_id')
      .where('orders.status != ?', :cancelled)
      .group('orders.id, users.id, order_items.updated_at, order_items.created_at')
      .order("time_diff #{order}")
      .limit(quantity)
  end

  def self.fastest_merchants(quantity)
    merchant_by_speed(quantity, :asc)
  end

  def self.slowest_merchants(quantity)
    merchant_by_speed(quantity, :desc)
  end

  def self.most_items_sold_past_month
    select('users.*, sum(order_items.quantity) as total_items')
    .joins(items: :order_items)
    .where('order_items.updated_at >= :start_time AND order_items.updated_at <= :end_time', {
      start_time: (Time.now - 1.month),
      end_time: Time.now
    })
    .where('order_items.fulfilled = true')
    .group('users.id').order('total_items DESC')
    .limit(10)
  end


  def self.most_fulfilled_orders_past_month
    select('users.*, count(order_items.order_id) as total_orders')
    .joins(:items)
    .joins(items: { order_items: :order })
    .where('orders.status != ?', :cancelled)
    .where('order_items.updated_at >= :start_time AND order_items.updated_at <= :end_time', {
      start_time: (Time.now - 1.month),
      end_time: Time.now
      })
    .where('order_items.fulfilled = true')
    .group('users.id')
    .order('total_orders DESC')
    .limit(10)
  end

  def customers
    User
    .joins(orders: {order_items: :item})
    .where('items.user_id = ?', self.id)
    .where('users.active = true')
    .distinct
  end

  def non_customers
    customer_ids = self.customers.pluck(:id)
    User
    .select('users.*')
    .where('users.active = true')
    .where.not(id: self.id)
    .where.not(id: customer_ids)
  end

  def self.to_csv
    attributes = %w{email}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      self.all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end

end
