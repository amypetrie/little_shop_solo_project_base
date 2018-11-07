require 'factory_bot_rails'

include FactoryBot::Syntax::Methods

OrderItem.destroy_all
Order.destroy_all
Item.destroy_all
User.destroy_all

admin = create(:admin)
user = create(:user)
merchant_1 = create(:merchant)

amy = create(:admin, email: "amyp@gmail.com", password: "password")

merchant_2, merchant_3, merchant_4 = create_list(:merchant, 3)

item_1 = create(:item, user: merchant_1)
item_2 = create(:item, user: merchant_2)
item_3 = create(:item, user: merchant_3)
item_4 = create(:item, user: merchant_4)
create_list(:item, 10, user: merchant_1)

order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_1, price: 1, quantity: 10, updated_at: Time.now, created_at: Time.now - 1.days)
create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 5, updated_at: Time.now, created_at: Time.now - 2.days)
create(:fulfilled_order_item, order: order, item: item_4, price: 4, quantity: 1, updated_at: Time.now, created_at: Time.now)

order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_1, price: 1, quantity: 9, updated_at: Time.now, created_at: Time.now - 1.days)
create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 4,updated_at: Time.now, created_at: Time.now - 2.days)
create(:fulfilled_order_item, order: order, item: item_4, price: 2, quantity: 1, updated_at: Time.now, created_at: Time.now)


order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1, updated_at: Time.now, created_at: Time.now - 2.days)
create(:fulfilled_order_item, order: order, item: item_3, price: 3, quantity: 2, updated_at: Time.now, created_at: Time.now - 5.days)
create(:fulfilled_order_item, order: order, item: item_4, price: 2, quantity: 1, updated_at: Time.now, created_at: Time.now)

order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_4, price: 2, quantity: 1, updated_at: Time.now, created_at: Time.now)
