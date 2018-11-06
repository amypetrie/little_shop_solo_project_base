require 'rails_helper'

  describe 'a merchant visits the dashboard' do
    before(:each) do
      @merchant = create(:merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      visit dashboard_path
    end

    it 'should show me a button to export customer emails, and a button for non customer emails' do
      expect(page).to have_button("Export Customer Emails")
      expect(page).to have_button("Export Non Customer Emails")
    end

    it 'can click the export customer emails button' do
      click_on("Export Customer Emails")
      expect(current_path).to eq('/dashboard/customer_emails.csv')
    end

    it 'can export customer emails csv' do
      user_1, user_2, user_3, user_4, user_5, user_6 = create_list(:user, 6)
      merchant_1, merchant_2, merchant_3, merchant_4 = create_list(:merchant, 4)
      item_1 = create(:item, user: merchant_1)
      item_2 = create(:item, user: merchant_2)
      item_3 = create(:item, user: merchant_3)
      item_4 = create(:item, user: merchant_4)

      item_5 = create(:item, user: merchant_1)
      item_6 = create(:item, user: merchant_2)
      item_7 = create(:item, user: merchant_3)
      item_8 = create(:item, user: merchant_4)

      order = create(:completed_order, user: user_1)
      create(:fulfilled_order_item, order: order, item: item_1, price: 20000, quantity: 1)
      create(:fulfilled_order_item, order: order, item: item_5, price: 20000, quantity: 1)

      order = create(:completed_order, user: user_2)
      create(:fulfilled_order_item, order: order, item: item_1, price: 20000, quantity: 1)
      create(:fulfilled_order_item, order: order, item: item_5, price: 20000, quantity: 1)

      order = create(:completed_order, user: user_3)
      create(:fulfilled_order_item, order: order, item: item_1, price: 20000, quantity: 1)
      create(:fulfilled_order_item, order: order, item: item_5, price: 20000, quantity: 1)

      order = create(:order, user: user_4)
      create(:order_item, order: order, item: item_1, price: 20000, quantity: 1, fulfilled: false)
      create(:order_item, order: order, item: item_5, price: 20000, quantity: 1, fulfilled: false)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_1)

      click_on("Export Customer Emails")
      expect(page).to have_content(user_1.name)
      expect(page).to have_content(user_2.name)
      expect(page).to have_content(user_3.name)
      expect(page).to have_content(user_4.name)

      expect(page).to have_content(user_1.email)
      expect(page).to have_content(user_2.email)
      expect(page).to have_content(user_3.email)
      expect(page).to have_content(user_4.email)

      expect(page).to_not have_content(user_5.email)
      expect(page).to_not have_content(merchant_1.email)
      expect(page).to_not have_content(merchant_2.email)
      expect(page).to_not have_content(merchant_3.email)
      expect(page).to_not have_content(merchant_4.email)

      expect(page).to_not have_content(user_5.name)
      expect(page).to_not have_content(merchant_1.name)
      expect(page).to_not have_content(merchant_2.name)
      expect(page).to_not have_content(merchant_3.name)
      expect(page).to_not have_content(merchant_4.name)
    end

    it 'can click the export non customer emails button' do
      click_on("Export Non Customer Emails")
      expect(current_path).to eq('/dashboard/non_customer_emails.csv')
    end

    it 'can export non customer emails csv' do
      user_1, user_2, user_3, user_4, user_5, user_6 = create_list(:user, 6)
      merchant_1, merchant_2, merchant_3, merchant_4 = create_list(:merchant, 4)
      item_1 = create(:item, user: merchant_1)
      item_2 = create(:item, user: merchant_2)
      item_3 = create(:item, user: merchant_3)
      item_4 = create(:item, user: merchant_4)

      item_5 = create(:item, user: merchant_1)
      item_6 = create(:item, user: merchant_2)
      item_7 = create(:item, user: merchant_3)
      item_8 = create(:item, user: merchant_4)

      order = create(:completed_order, user: user_1)
      create(:fulfilled_order_item, order: order, item: item_1, price: 20000, quantity: 1)
      create(:fulfilled_order_item, order: order, item: item_5, price: 20000, quantity: 1)

      order = create(:completed_order, user: user_2)
      create(:fulfilled_order_item, order: order, item: item_1, price: 20000, quantity: 1)
      create(:fulfilled_order_item, order: order, item: item_5, price: 20000, quantity: 1)

      order = create(:completed_order, user: user_3)
      create(:fulfilled_order_item, order: order, item: item_1, price: 20000, quantity: 1)
      create(:fulfilled_order_item, order: order, item: item_5, price: 20000, quantity: 1)

      order = create(:order, user: user_4)
      create(:order_item, order: order, item: item_1, price: 20000, quantity: 1, fulfilled: false)
      create(:order_item, order: order, item: item_5, price: 20000, quantity: 1, fulfilled: false)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_1)

      click_on("Export Non Customer Emails")
      expect(page).to_not have_content(user_1.name)
      expect(page).to_not have_content(user_2.name)
      expect(page).to_not have_content(user_3.name)
      expect(page).to_not have_content(user_4.name)
      expect(page).to_not have_content(merchant_1.name)

      expect(page).to_not have_content(user_1.email)
      expect(page).to_not have_content(user_2.email)
      expect(page).to_not have_content(user_3.email)
      expect(page).to_not have_content(user_4.email)
      expect(page).to_not have_content(merchant_1.email)

      expect(page).to have_content(user_5.email)
      expect(page).to have_content(merchant_2.email)
      expect(page).to have_content(merchant_3.email)
      expect(page).to have_content(merchant_4.email)

      expect(page).to have_content(user_5.name)
      expect(page).to have_content(merchant_2.name)
      expect(page).to have_content(merchant_3.name)
      expect(page).to have_content(merchant_4.name)
    end
  end
