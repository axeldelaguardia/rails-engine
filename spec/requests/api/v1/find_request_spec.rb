require "rails_helper"

describe "Find API" do
	context "finds all items" do
		it "sends items that match keyword" do
			merchant = create(:merchant)
			item_1 = create(:item, name: "Table Saw", merchant: merchant)
			item_2 = create(:item, name: "Crosstable", merchant: merchant)
			item_3 = create(:item, name: "Hammer", merchant: merchant)
			item_4 = create(:item, name: "Turn Table", merchant: merchant)

			get "/api/v1/items/find_all?name=table"
			
			expect(response).to be_successful

			items = JSON.parse(response.body, symbolize_names: true)

			expect(items).to be_a(Hash)
			expect(items[:data]).to be_an(Array)

			items[:data].each do |item|
				expect(item).to have_key(:id)
				expect(item[:id]).to be_a(String)

				expect(item).to have_key(:type)
				expect(item[:type]).to be_a(String)

				expect(item).to have_key(:attributes)
				expect(item[:attributes]).to be_a(Hash)

				expect(item[:attributes].keys).to include(:name, :description, :unit_price, :merchant_id)
				expect(item[:attributes][:name]).to be_a(String)
				expect(item[:attributes][:description]).to be_a(String)
				expect(item[:attributes][:unit_price]).to be_a(Float)
				expect(item[:attributes][:merchant_id]).to be_an(Integer)
			end
		end

		it "can search by both min_price and max_price" do
			item_1 = create(:item, unit_price: 4.99)
			item_2 = create(:item, unit_price: 5.69)
			item_3 = create(:item, unit_price: 3.25)
			item_4 = create(:item, unit_price: 2.99)

			get "/api/v1/items/find_all?min_price=3.25&max_price=4.99"

			expect(response).to be_successful

			items = JSON.parse(response.body, symbolize_names: true)

			expect(items).to have_key(:data)
			expect(items[:data]).to be_an(Array)
			expect(items[:data].size).to eq(2)

			items[:data].each do |item|
				expect(item.keys).to include(:id, :type, :attributes)
				expect(item[:id]).to be_a(String)
				expect(item[:type]).to be_a(String)
				expect(item[:attributes]).to be_a(Hash)

				expect(item[:attributes].keys).to include(:name, :description, :unit_price, :merchant_id)
				expect(item[:attributes][:name]).to be_a(String)
				expect(item[:attributes][:description]).to be_a(String)
				expect(item[:attributes][:unit_price]).to be_a(Float)
				expect(item[:attributes][:merchant_id]).to be_an(Integer)
			end
		end

		it "can search by both min_price" do
			item_1 = create(:item, unit_price: 4.99)
			item_2 = create(:item, unit_price: 5.69)
			item_3 = create(:item, unit_price: 3.25)
			item_4 = create(:item, unit_price: 2.99)

			get "/api/v1/items/find_all?min_price=3.25"

			expect(response).to be_successful

			items = JSON.parse(response.body, symbolize_names: true)

			expect(items).to have_key(:data)
			expect(items[:data]).to be_an(Array)
			expect(items[:data].size).to eq(3)

			items[:data].each do |item|
				expect(item.keys).to include(:id, :type, :attributes)
				expect(item[:id]).to be_a(String)
				expect(item[:type]).to be_a(String)
				expect(item[:attributes]).to be_a(Hash)

				expect(item[:attributes].keys).to include(:name, :description, :unit_price, :merchant_id)
				expect(item[:attributes][:name]).to be_a(String)
				expect(item[:attributes][:description]).to be_a(String)
				expect(item[:attributes][:unit_price]).to be_a(Float)
				expect(item[:attributes][:merchant_id]).to be_an(Integer)
			end
		end

		it "can search by both max_price" do
			item_1 = create(:item, unit_price: 4.99)
			item_2 = create(:item, unit_price: 5.69)
			item_3 = create(:item, unit_price: 3.25)
			item_4 = create(:item, unit_price: 2.99)

			get "/api/v1/items/find_all?max_price=4.99"

			expect(response).to be_successful

			items = JSON.parse(response.body, symbolize_names: true)

			expect(items).to have_key(:data)
			expect(items[:data]).to be_an(Array)
			expect(items[:data].size).to eq(3)

			items[:data].each do |item|
				expect(item.keys).to include(:id, :type, :attributes)
				expect(item[:id]).to be_a(String)
				expect(item[:type]).to be_a(String)
				expect(item[:attributes]).to be_a(Hash)

				expect(item[:attributes].keys).to include(:name, :description, :unit_price, :merchant_id)
				expect(item[:attributes][:name]).to be_a(String)
				expect(item[:attributes][:description]).to be_a(String)
				expect(item[:attributes][:unit_price]).to be_a(Float)
				expect(item[:attributes][:merchant_id]).to be_an(Integer)
			end
		end

		it "sends message if no records found" do
			merchant = create(:merchant)
			item_1 = create(:item, name: "Table Saw", merchant: merchant)
			item_2 = create(:item, name: "Crosstable", merchant: merchant)
			item_3 = create(:item, name: "Hammer", merchant: merchant)
			item_4 = create(:item, name: "Turn Table", merchant: merchant)

			get "/api/v1/items/find_all?name=ring"
			
			expect(response).to have_http_status(200)
			
			items = JSON.parse(response.body, symbolize_names: true)
			
			expect(items).to have_key(:data)
			expect(items[:data]).to be_an(Array)
			expect(items[:data]).to be_empty
			# expect(items).to have_key(:message)
			# expect(items[:message]).to be_a(String)
			# expect(items[:message]).to eq("your query could not be completed")
			# expect(items).to have_key(:errors)
			# expect(items[:errors]).to be_an(Array)

			# items[:errors].each do |error|
			# 	expect(error).to be_a(String)
			# end

			# expect(items[:errors].first).to eq("no records found with that keyword")
		end

		it "sends message that cannot search by both name and max price" do
			merchant = create(:merchant)
			item_1 = create(:item, name: "Table Saw", merchant: merchant)
			item_2 = create(:item, name: "Crosstable", merchant: merchant)
			item_3 = create(:item, name: "Hammer", merchant: merchant)
			item_4 = create(:item, name: "Turn Table", merchant: merchant)

			get "/api/v1/items/find_all?name=ring&max_price=4.99"
			
			expect(response).to have_http_status(400)
			
			response_body = JSON.parse(response.body, symbolize_names: true)
			
			expect(response_body).to have_key(:message)
			expect(response_body[:message]).to be_a(String)
			expect(response_body[:message]).to eq("your query could not be completed")
			expect(response_body).to have_key(:errors)
			expect(response_body[:errors]).to be_an(Array)

			response_body[:errors].each do |error|
				expect(error).to be_a(String)
			end

			expect(response_body[:errors].first).to eq("cannot search by both name and unit price")
		end

		it "sends message that cannot search by both name and min price" do
			merchant = create(:merchant)
			item_1 = create(:item, name: "Table Saw", merchant: merchant)
			item_2 = create(:item, name: "Crosstable", merchant: merchant)
			item_3 = create(:item, name: "Hammer", merchant: merchant)
			item_4 = create(:item, name: "Turn Table", merchant: merchant)

			get "/api/v1/items/find_all?name=ring&min_price=4.99"
			
			expect(response).to have_http_status(400)
			
			response_body = JSON.parse(response.body, symbolize_names: true)
			
			expect(response_body).to have_key(:message)
			expect(response_body[:message]).to be_a(String)
			expect(response_body[:message]).to eq("your query could not be completed")
			expect(response_body).to have_key(:errors)
			expect(response_body[:errors]).to be_an(Array)

			response_body[:errors].each do |error|
				expect(error).to be_a(String)
			end

			expect(response_body[:errors].first).to eq("cannot search by both name and unit price")
		end

		it "sends message that cannot search by both name, min price, and max price" do
			merchant = create(:merchant)
			item_1 = create(:item, name: "Table Saw", merchant: merchant)
			item_2 = create(:item, name: "Crosstable", merchant: merchant)
			item_3 = create(:item, name: "Hammer", merchant: merchant)
			item_4 = create(:item, name: "Turn Table", merchant: merchant)

			get "/api/v1/items/find_all?name=ring&min_price=4.99&max_price=7.99"
			
			expect(response).to have_http_status(400)
			
			response_body = JSON.parse(response.body, symbolize_names: true)
			
			expect(response_body).to have_key(:message)
			expect(response_body[:message]).to be_a(String)
			expect(response_body[:message]).to eq("your query could not be completed")
			expect(response_body).to have_key(:errors)
			expect(response_body[:errors]).to be_an(Array)

			response_body[:errors].each do |error|
				expect(error).to be_a(String)
			end

			expect(response_body[:errors].first).to eq("cannot search by both name and unit price")
		end

		it "sends a message when min price is less than 0" do
			merchant = create(:merchant)
			item_1 = create(:item, name: "Table Saw", merchant: merchant)
			item_2 = create(:item, name: "Crosstable", merchant: merchant)
			item_3 = create(:item, name: "Hammer", merchant: merchant)
			item_4 = create(:item, name: "Turn Table", merchant: merchant)

			get "/api/v1/items/find_all?min_price=-2"

			expect(response).to have_http_status(400)

			response_body = JSON.parse(response.body, symbolize_names: true)

			expect(response_body).to have_key(:message)
			expect(response_body[:message]).to be_a(String)
			expect(response_body[:message]).to eq("your query could not be completed")
			expect(response_body).to have_key(:errors)
			expect(response_body[:errors]).to be_an(Array)

			response_body[:errors].each do |error|
				expect(error).to be_a(String)
			end

			expect(response_body[:errors].first).to eq("min_price and max_price must be greater than or equal to 0")
		end

		it "sends a message when max price is less than 0" do
			merchant = create(:merchant)
			item_1 = create(:item, name: "Table Saw", merchant: merchant)
			item_2 = create(:item, name: "Crosstable", merchant: merchant)
			item_3 = create(:item, name: "Hammer", merchant: merchant)
			item_4 = create(:item, name: "Turn Table", merchant: merchant)

			get "/api/v1/items/find_all?max_price=-2"

			expect(response).to have_http_status(400)

			response_body = JSON.parse(response.body, symbolize_names: true)

			expect(response_body).to have_key(:message)
			expect(response_body[:message]).to be_a(String)
			expect(response_body[:message]).to eq("your query could not be completed")
			expect(response_body).to have_key(:errors)
			expect(response_body[:errors]).to be_an(Array)

			response_body[:errors].each do |error|
				expect(error).to be_a(String)
			end

			expect(response_body[:errors].first).to eq("min_price and max_price must be greater than or equal to 0")
		end
	end

	context "find single merchant" do
		it "sends a single merchant" do
			merchant_1 = create(:merchant, name: "Red Star")
			merchant_2 = create(:merchant)

			get "/api/v1/merchants/find?name=red"

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

		it "sends message no records found if none returned" do
			get "/api/v1/merchants/find?name=red"

			expect(response).to have_http_status(200)
			
			response_body = JSON.parse(response.body, symbolize_names: true)

			expect(response_body).to have_key(:data)
			expect(response_body[:data]).to be_an(Hash)
			expect(response_body[:data]).to be_empty
		end

		it "sends a message when parameter is missing" do
			get "/api/v1/merchants/find?name="

			expect(response).to have_http_status(200)
			
			response_body = JSON.parse(response.body, symbolize_names: true)

			expect(response_body).to have_key(:data)
			expect(response_body[:data]).to be_an(Hash)
			expect(response_body[:data]).to be_empty
		end
	end
end