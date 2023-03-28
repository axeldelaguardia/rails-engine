require "rails_helper"

describe "Items API" do
	context "index" do
		it "sends a list of customers" do
			merchant = create(:merchant)
			create_list(:item, 3, merchant: merchant)

			get "/api/v1/items"

			expect(response).to be_successful
			
			items = JSON.parse(response.body, symbolize_names: true)
			
			expect(items).to have_key(:data)
			expect(items[:data]).to be_an(Array)

			expect(items[:data].count).to eq(3)
			
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
	end
	
	context "show" do
		it "sends one item" do
			merchant = create(:merchant)
			item_1 = create(:item, merchant: merchant)

			get "/api/v1/items/#{item_1.id}"

			expect(response).to be_successful

			item = JSON.parse(response.body, symbolize_names: true)
		
			expect(item).to be_a(Hash)
			expect(item).to have_key(:data)
			expect(item[:data]).to be_a(Hash)

			expect(item[:data]).to have_key(:id)
			expect(item[:data][:id]).to be_an(String)

			expect(item[:data]).to have_key(:type)
			expect(item[:data][:type]).to be_an(String)

			expect(item[:data]).to have_key(:attributes)
			expect(item[:data][:attributes]).to be_a(Hash)

			expect(item[:data][:attributes]).to have_key(:name)
			expect(item[:data][:attributes][:name]).to be_a(String)

			expect(item[:data][:attributes]).to have_key(:description)
			expect(item[:data][:attributes][:description]).to be_a(String)

			expect(item[:data][:attributes]).to have_key(:unit_price)
			expect(item[:data][:attributes][:unit_price]).to be_an(Float)

			expect(item[:data][:attributes]).to have_key(:merchant_id)
			expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
		end

		it "returns status code 404 if bad id" do
			merchant = create(:merchant)
			item_1 = create(:item, merchant: merchant)

			get "/api/v1/items/#{item_1.id + 1}"

			expect(response).to have_http_status(404)
			
			response_body = JSON.parse(response.body, symbolize_names: true)

			expect(response_body).to have_key(:message)
			expect(response_body[:message]).to be_a(String)
			expect(response_body[:message]).to eq("your query could not be completed")

			expect(response_body).to have_key(:errors)
			expect(response_body[:errors]).to be_an(Array)
			expect(response_body[:errors].first).to be_a(Hash)
			expect(response_body[:errors].first[:message]).to eq("Couldn't find Item with 'id'=#{item_1.id + 1}")
		end

		it "returns status code 404 if string instead of integer id" do
			merchant = create(:merchant)
			item_1 = create(:item, merchant: merchant)

			get "/api/v1/items/string-instead-of-integer"

			expect(response).to have_http_status(404)
			
			response_body = JSON.parse(response.body, symbolize_names: true)
			expect(response_body).to have_key(:message)
			expect(response_body[:message]).to be_a(String)
			expect(response_body[:message]).to eq("your query could not be completed")

			expect(response_body).to have_key(:errors)
			expect(response_body[:errors]).to be_an(Array)
			expect(response_body[:errors].first).to be_a(Hash)
			expect(response_body[:errors].first[:message]).to eq("Couldn't find Item with 'id'=string-instead-of-integer")
		end
	end

	context "create" do
		it "can create an item" do
			merchant = create(:merchant)

			item_params = ({
				name: "New Item",
				description: "Item Description",
				unit_price: 45.0,
				merchant_id: merchant.id
			})

			headers = {"CONTENT_TYPE" => "application/json"}

			post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
			
			created_item = Item.last

			expect(response).to have_http_status(201)

			expect(created_item.name).to eq(item_params[:name])
			expect(created_item.description).to eq(item_params[:description])
			expect(created_item.unit_price).to eq(item_params[:unit_price])
			expect(created_item.merchant_id).to eq(item_params[:merchant_id])
		end

		it "returns an error when wrong inputs to create item" do
			merchant = create(:merchant)

			item_params = ({
				name: 345,
				description: 546,
				unit_price: "string",
				merchant_id: merchant.id
			})

			headers = {"CONTENT_TYPE" => "application/json"}

			post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
			
			expect(response).to have_http_status(404)

			response_body = JSON.parse(response.body, symbolize_names: true)
			
			expect(response_body).to have_key(:message)
			expect(response_body[:message]).to be_a(String)
			expect(response_body[:message]).to eq("your query could not be completed")
			
			expect(response_body).to have_key(:errors)
			expect(response_body[:errors]).to be_an(Array)

			expect(response_body[:errors].first).to be_a(Hash)
			expect(response_body[:errors].first).to have_key(:name)
			expect(response_body[:errors].second).to have_key(:unit_price)

			expect(response_body[:errors].first[:name]).to be_an(String)
			expect(response_body[:errors].first[:name]).to eq("only allows letters and white spaces")

			expect(response_body[:errors].second[:unit_price]).to be_an(String)
			expect(response_body[:errors].second[:unit_price]).to eq("must be a valid float")
		end
	end

	context "delete" do
		it "can delete an item" do
			merchant_1 = create(:merchant)

			item_1 = create(:item, merchant: merchant_1)

			delete "/api/v1/items/#{item_1.id}"

			expect(response).to have_http_status(204)

			expect(Item.last).to be(nil)
		end
	end

	context "update" do
		it "can edit an item" do
			merchant = create(:merchant)
			item = create(:item, merchant: merchant)

			item_params = ({
				name: "Updated Item",
				description: "Item Description",
				unit_price: 45.0,
				merchant_id: merchant.id
			})

			headers = {"CONTENT_TYPE" => "application/json"}
			
			expect(item.name).to_not eq(item_params[:name])
			expect(item.description).to_not eq(item_params[:description])
			expect(item.unit_price).to_not eq(item_params[:unit_price])

			patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)

			expect(Item.last.name).to eq(item_params[:name])
			expect(Item.last.description).to eq(item_params[:description])
			expect(Item.last.unit_price).to eq(item_params[:unit_price])
		end

		it "can edit an item with partial data" do
			merchant = create(:merchant)
			item = create(:item, merchant: merchant)

			item_params = ({
				name: "Updated Item"
			})

			headers = {"CONTENT_TYPE" => "application/json"}
			
			expect(item.name).to_not eq(item_params[:name])
			expect(item.description).to_not eq(item_params[:description])
			expect(item.unit_price).to_not eq(item_params[:unit_price])

			patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)

			expect(Item.last.name).to eq(item_params[:name])
			expect(Item.last.description).to eq(item.description)
			expect(Item.last.unit_price).to eq(item.unit_price)
		end

		it "returns status 404 is bad merchant id" do
			merchant = create(:merchant)
			item = create(:item, merchant: merchant)

			item_params = ({
				name: "Updated Item",
				merchant_id: 10000
			})

			headers = {"CONTENT_TYPE" => "application/json"}
			
			expect(item.name).to_not eq(item_params[:name])
			expect(item.description).to_not eq(item_params[:description])
			expect(item.unit_price).to_not eq(item_params[:unit_price])

			patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)

			expect(response).to have_http_status(404)

			response_body = JSON.parse(response.body, symbolize_names: true)
			
			expect(response_body).to have_key(:message)
			expect(response_body[:message]).to be_a(String)
			expect(response_body[:message]).to eq("your query could not be completed")

			expect(response_body).to have_key(:errors)
			expect(response_body[:errors]).to be_an(Array)
			expect(response_body[:errors].first).to be_a(Hash)
			expect(response_body[:errors].first).to have_key(:merchant)
			expect(response_body[:errors].first[:merchant]).to eq("required")

		end

		it "returns status 404 when a string is used as an id" do
			merchant = create(:merchant)
			item = create(:item, merchant: merchant)

			item_params = ({
				name: "Updated Item",
				merchant_id: "string"
			})

			headers = {"CONTENT_TYPE" => "application/json"}
			
			expect(item.name).to_not eq(item_params[:name])
			expect(item.description).to_not eq(item_params[:description])
			expect(item.unit_price).to_not eq(item_params[:unit_price])

			patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)

			expect(response).to have_http_status(404)
		end
	end

	context "item's merchant" do
		it "sends an items merchant" do
			merchant_1 = create(:merchant)
			item = create(:item, merchant: merchant_1)

			get "/api/v1/items/#{item.id}/merchant"

			expect(response).to be_successful

			merchant = JSON.parse(response.body, symbolize_names: true)

			expect(merchant).to be_a(Hash)
			expect(merchant).to have_key(:data)
			expect(merchant[:data]).to be_a(Hash)

			expect(merchant[:data]).to have_key(:id)
			expect(merchant[:data][:id]).to be_a(String)

			expect(merchant[:data]).to have_key(:type)
			expect(merchant[:data][:type]).to be_a(String)

			expect(merchant[:data]).to have_key(:attributes)
			expect(merchant[:data][:attributes]).to be_a(Hash)

			expect(merchant[:data][:attributes]).to have_key(:name)
			expect(merchant[:data][:attributes][:name]).to be_a(String)
		end

		it "returns status 404 if bad id" do
			merchant_1 = create(:merchant)
			item = create(:item, merchant: merchant_1, id: "100")
			
			get "/api/v1/items/#{Item.last.id + 1}/merchant"

			expect(response).to have_http_status(404)

			response_body = JSON.parse(response.body, symbolize_names: true)

			expect(response_body).to have_key(:message)
			expect(response_body[:message]).to be_a(String)
			expect(response_body[:message]).to eq("your query could not be completed")

			expect(response_body).to have_key(:errors)
			expect(response_body[:errors]).to be_an(Array)
			expect(response_body[:errors].first).to be_a(Hash)
			expect(response_body[:errors].first).to have_key(:message)
			expect(response_body[:errors].first[:message]).to be_a(String)
			expect(response_body[:errors].first[:message]).to eq("Couldn't find Item with 'id'=#{Item.last.id + 1}")
		end
	end
end