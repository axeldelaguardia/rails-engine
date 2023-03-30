require "rails_helper"

describe "Merchant API" do
	it "sends a list of merchants - index action" do
		create_list(:merchant, 3)

		get "/api/v1/merchants"

		expect(response).to be_successful
		
		merchants = JSON.parse(response.body, symbolize_names: true)
		
		expect(merchants).to have_key(:data)

		expect(merchants[:data].count).to eq(3)
		expect(merchants[:data]).to be_an(Array)
		
		merchants[:data].each do |merchant|
			expect(merchant).to have_key(:id)
			expect(merchant[:id]).to be_an(String)
			
			expect(merchant).to have_key(:type)
			expect(merchant[:type]).to be_a(String)

			expect(merchant[:attributes]).to have_key(:name)
			expect(merchant[:attributes][:name]).to be_a(String)
		end
	end

	context "show" do
		it "sends a merchant - show action" do
			merchant_1 = create(:merchant)

			get "/api/v1/merchants/#{merchant_1.id}"

			expect(response).to be_successful

			merchant = JSON.parse(response.body, symbolize_names: true)
			
			expect(merchant).to be_a(Hash)

			expect(merchant).to have_key(:data)

			expect(merchant[:data]).to have_key(:id)
			expect(merchant[:data][:id]).to be_an(String)

			expect(merchant[:data]).to have_key(:type)
			expect(merchant[:data][:type]).to be_an(String)

			expect(merchant[:data]).to have_key(:attributes)
			expect(merchant[:data][:attributes]).to be_a(Hash)

			expect(merchant[:data][:attributes]).to have_key(:name)
			expect(merchant[:data][:attributes][:name]).to be_a(String)
		end

		it "sad path when incorrect id" do
			get "/api/v1/merchants/1"

			expect(response).to have_http_status(404)
			
			response_body = JSON.parse(response.body, symbolize_names: true)

			expect(response_body).to have_key(:message)
			expect(response_body[:message]).to eq("your query could not be completed")
			expect(response_body).to have_key(:errors)
			expect(response_body[:errors]).to be_an(Array)

			response_body[:errors].each do |error|
				expect(error).to be_a(Hash)
				expect(error.keys).to include(:status, :title)
				expect(error[:status]).to be_a(String)
				expect(error[:title]).to be_a(String)
			end

			expect(response_body[:errors].first[:status]).to eq("404")
			expect(response_body[:errors].first[:title]).to eq("Couldn't find Merchant with 'id'=1")
		end
	end
		
	context "merchant items" do
		it "sends all merchant items" do
			merchant_1 = create(:merchant)
			create_list(:item, 5, merchant: merchant_1)

			get "/api/v1/merchants/#{merchant_1.id}/items"

			expect(response).to be_successful

			items = JSON.parse(response.body, symbolize_names: true)

			expect(items).to be_a(Hash)
			expect(items).to have_key(:data)
			expect(items[:data]).to be_an(Array)

			items[:data].each do |item|
				expect(item).to have_key(:id)
				expect(item[:id]).to be_a(String)

				expect(item).to have_key(:type)
				expect(item[:type]).to be_a(String)

				expect(item).to have_key(:attributes)
				expect(item[:attributes]).to be_a(Hash)

				expect(item[:attributes]).to have_key(:name)
				expect(item[:attributes][:name]).to be_a(String)

				expect(item[:attributes]).to have_key(:description)
				expect(item[:attributes][:description]).to be_a(String)

				expect(item[:attributes]).to have_key(:unit_price)
				expect(item[:attributes][:unit_price]).to be_a(Float)
			end
		end

		it "return status code 404 when bad id" do
			merchant_1 = create(:merchant)
			create_list(:item, 5, merchant: merchant_1)

			get "/api/v1/merchants/#{Merchant.last.id + 1}/items"

			expect(response).to have_http_status(404)
		end
	end
end