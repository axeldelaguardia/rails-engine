require "rails_helper"

describe "Items API" do
	it "sends a list of customers - index action" do
		merchant = create(:merchant)
		create_list(:item, 3, merchant: merchant)

		get "/api/v1/items"

		expect(response).to be_successful
		
		items = JSON.parse(response.body, symbolize_names: true)

		expect(items.count).to eq(3)
		expect(items).to be_an(Array)
		
		items.each do |item|
			expect(item).to have_key(:id)
			expect(item[:id]).to be_an(Integer)

			expect(item).to have_key(:name)
			expect(item[:name]).to be_a(String)

			expect(item).to have_key(:description)
			expect(item[:description]).to be_a(String)

			expect(item).to have_key(:merchant_id)
			expect(item[:merchant_id]).to be_an(Integer)

			expect(item).to have_key(:created_at)
			expect(item[:created_at]).to be_a(String)

			expect(item).to have_key(:updated_at)
			expect(item[:updated_at]).to be_a(String)
		end
	end

	it "sends one item - show action" do
		merchant = create(:merchant)
		item_1 = create(:item, merchant: merchant)

		get "/api/v1/items/#{item_1.id}"

		expect(response).to be_successful

		item = JSON.parse(response.body, symbolize_names: true)
		
		expect(item).to be_a(Hash)
		
		expect(item).to have_key(:id)
		expect(item[:id]).to be_an(Integer)

		expect(item).to have_key(:name)
		expect(item[:name]).to be_a(String)

		expect(item).to have_key(:description)
		expect(item[:description]).to be_a(String)

		expect(item).to have_key(:unit_price)
		expect(item[:unit_price]).to be_an(Float)

		expect(item).to have_key(:merchant_id)
		expect(item[:merchant_id]).to be_an(Integer)

		expect(item).to have_key(:created_at)
		expect(item[:created_at]).to be_a(String)

		expect(item).to have_key(:updated_at)
		expect(item[:updated_at]).to be_a(String)
	end
end