require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
  end

	describe "#destroy_invoice" do
		it "deletes an invoice if the item was the only thing on it" do
			merchant = create(:merchant)

			item_1 = create(:item, merchant: merchant)
			item_2 = create(:item, merchant: merchant)

			customer_1 = create(:customer)
			customer_2 = create(:customer)

			invoice_1 = create(:invoice, merchant: merchant, customer: customer_1)
			invoice_2 = create(:invoice, merchant: merchant, customer: customer_2)

			create(:invoice_item, item: item_1, invoice: invoice_1)
			create(:invoice_item, item: item_1, invoice: invoice_2)
			create(:invoice_item, item: item_2, invoice: invoice_2)

			expect(item_1.single_invoices).to eq([invoice_1])
		end
	end
end