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

	describe "::find_all" do
		it "returns all records that match the keyword" do
			merchant = create(:merchant)
			item_1 = create(:item, name: "Table Saw", merchant: merchant)
			item_2 = create(:item, name: "Crosstable", merchant: merchant)
			item_3 = create(:item, name: "Hammer", merchant: merchant)
			item_4 = create(:item, name: "Turn Table", merchant: merchant)

			expect(Item.find_by_name("table")).to eq([item_1, item_2, item_4])
		end

		it "returns all records greater than a given price" do
			merchant = create(:merchant)
			item_1 = create(:item, unit_price: 4.99)
			item_2 = create(:item, unit_price: 5.69)
			item_3 = create(:item, unit_price: 3.25)
			item_4 = create(:item, unit_price: 2.99)

			expect(Item.find_by_price({min_price: 4.99})).to eq([item_1, item_2])
		end

		it "returns all records greater than a given price" do
			merchant = create(:merchant)
			item_1 = create(:item, unit_price: 4.99)
			item_2 = create(:item, unit_price: 5.69)
			item_3 = create(:item, unit_price: 3.25)
			item_4 = create(:item, unit_price: 2.99)

			expect(Item.find_by_price({max_price: 4.99})).to eq([item_1, item_3, item_4])
		end

		it "returns all records between given prices" do
			merchant = create(:merchant)
			item_1 = create(:item, unit_price: 4.99)
			item_2 = create(:item, unit_price: 5.69)
			item_3 = create(:item, unit_price: 3.25)
			item_4 = create(:item, unit_price: 2.99)
			item_5 = create(:item, unit_price: 3.99)

			expect(Item.find_by_price({max_price: 4.99, min_price: 3.25})).to eq([item_1, item_3, item_5])
		end
	end
end