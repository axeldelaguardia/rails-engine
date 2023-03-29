class Api::V1::Items::FindController < ApplicationController
	def index
		if params[:name] && (check_min_max_price)
			invalid_search("cannot search by both name and unit price")
		elsif params[:name]
			items = Item.find_by_name(params[:name])
			render json: ItemSerializer.new(items)
		elsif check_min_max_price
			items = Item.find_by_price(params)
			render json: ItemSerializer.new(items)
		else
			invalid_search("min_price and max_price must be greater than or equal to 0")
		end
	end

	private

	def invalid_search(message)
			render json: {
					"message": "your query could not be completed",
					"errors": [
						message
					]
		}, status: 400
	end

	def check_min_max_price
		params[:max_price] && params[:max_price].to_i >= 0 || 
		params[:min_price] && params[:min_price].to_i >= 0
	end
end