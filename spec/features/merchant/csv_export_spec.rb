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

    it 'can click the export buttons and will remain on same page' do
      click_on("Export Customer Emails")
      expect(current_path).to eq(dashboard_path)
    end
  end
