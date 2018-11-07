require 'factory_bot_rails'

include FactoryBot::Syntax::Methods

OrderItem.destroy_all
Order.destroy_all
Item.destroy_all
User.destroy_all

admin = create(:admin)
user = create(:user)
merchant_1 = create(:merchant, email: "merchant@gmail.com", password: "password")

amy = create(:admin, email: "admin@gmail.com", password: "password")

merchant_2, merchant_3, merchant_4 = create_list(:merchant, 3)
merchant_5, merchant_6, merchant_7 = create_list(:merchant, 3)
merchant_8, merchant_9, merchant_10 = create_list(:merchant, 3)

create_list(:user, 5)

user_2 = create(:user)
user_3 = create(:user)

item_1 = create(:item, user: merchant_1)
item_2 = create(:item, user: merchant_2)
item_3 = create(:item, user: merchant_3)
item_4 = create(:item, user: merchant_4)
item_5= create(:item, user: merchant_5)
item_6 = create(:item, user: merchant_6)
item_7 = create(:item, user: merchant_7)
item_8 = create(:item, user: merchant_8)
item_9 = create(:item, user: merchant_9)
item_10 = create(:item, user: merchant_10)

create_list(:item, 10, user: merchant_1)

order = create(:completed_order, user: user_2)
create(:fulfilled_order_item, order: order, item: item_1, price: 1, quantity: 10, updated_at: Time.now, created_at: Time.now - 1.days)
create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 5, updated_at: Time.now, created_at: Time.now - 2.days)
create(:fulfilled_order_item, order: order, item: item_4, price: 4, quantity: 1, updated_at: Time.now, created_at: Time.now)

order = create(:completed_order, user: user_3)
create(:fulfilled_order_item, order: order, item: item_1, price: 1, quantity: 9, updated_at: Time.now, created_at: Time.now - 1.days)
create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 4,updated_at: Time.now, created_at: Time.now - 2.days)
create(:fulfilled_order_item, order: order, item: item_4, price: 2, quantity: 1, updated_at: Time.now, created_at: Time.now)


order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1, updated_at: Time.now, created_at: Time.now - 2.days)
create(:fulfilled_order_item, order: order, item: item_3, price: 3, quantity: 2, updated_at: Time.now, created_at: Time.now - 5.days)
create(:fulfilled_order_item, order: order, item: item_1, price: 2, quantity: 1, updated_at: Time.now, created_at: Time.now)

order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_4, price: 2, quantity: 1, updated_at: Time.now, created_at: Time.now)




order = create(:completed_order, user: user_2)
create(:fulfilled_order_item, order: order, item: item_5, price: 1, quantity: 10, updated_at: Time.now, created_at: Time.now - 1.days)
create(:fulfilled_order_item, order: order, item: item_6, price: 2, quantity: 5, updated_at: Time.now, created_at: Time.now - 2.days)
create(:fulfilled_order_item, order: order, item: item_7, price: 4, quantity: 1, updated_at: Time.now, created_at: Time.now)

order = create(:completed_order, user: user_3)
create(:fulfilled_order_item, order: order, item: item_8, price: 1, quantity: 9, updated_at: Time.now, created_at: Time.now - 1.days)
create(:fulfilled_order_item, order: order, item: item_9, price: 2, quantity: 4,updated_at: Time.now, created_at: Time.now - 2.days)
create(:fulfilled_order_item, order: order, item: item_10, price: 2, quantity: 1, updated_at: Time.now, created_at: Time.now)


order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_10, price: 2, quantity: 1, updated_at: Time.now, created_at: Time.now - 2.days)
create(:fulfilled_order_item, order: order, item: item_7, price: 3, quantity: 2, updated_at: Time.now, created_at: Time.now - 5.days)
create(:fulfilled_order_item, order: order, item: item_8, price: 2, quantity: 1, updated_at: Time.now, created_at: Time.now)

order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_4, price: 2, quantity: 1, updated_at: Time.now, created_at: Time.now)

order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_10, price: 2, quantity: 1, updated_at: Time.now, created_at: Time.now - 2.days)
create(:fulfilled_order_item, order: order, item: item_6, price: 3, quantity: 2, updated_at: Time.now, created_at: Time.now - 5.days)
create(:fulfilled_order_item, order: order, item: item_5, price: 2, quantity: 1, updated_at: Time.now, created_at: Time.now)

order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_4, price: 2, quantity: 1, updated_at: Time.now, created_at: Time.now)
